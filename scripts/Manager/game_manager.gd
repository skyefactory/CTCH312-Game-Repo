extends Node
class_name GameManager

var pending_orders: Array[Order] = [] # pending orders
var completed_orders: Array[Order] = [] # completed orders
var recipes: Array[Recipe] = [] # collection of all recipes
var day_started: bool = false
@export var recipes_path: String # location of recipe resources
@export var order_time_min: int = 15 # minimum time between new orders
@export var order_time_max: int = 30 # maximum time between new orders
var accum = 0.0 # accumulator for tracking time between orders
var timer = 0 # timer for when the next order should be generated, set to a random value between order_time_min and order_time_max at the start of the day and after each order is generated.

#picks a random time for timer
func pick_random_time() -> int:
    return randi_range(order_time_min, order_time_max)

signal update_orders_ui #emitted whenever an order is added/removed from pending orders

#load all the recipes from recipes_path into the recipes array
func load_recipes() -> void:
    recipes.clear()
    var dir = DirAccess.open(recipes_path) # open the path
    if dir: # if the path was opened OK
        dir.list_dir_begin() # begin listing the dir
        var file_name = dir.get_next() # get the filename

        while file_name != "": # if filename is not empty
            if not dir.current_is_dir():
                var resource_path := recipes_path.path_join(file_name)
                # Exported builds may list remapped resources as *.remap.
                if resource_path.ends_with(".remap"):
                    resource_path = resource_path.trim_suffix(".remap")

                var recipe_resource = ResourceLoader.load(resource_path)
                if recipe_resource is Recipe:
                    recipes.append(recipe_resource)
            #get the next file
            file_name = dir.get_next()
        dir.list_dir_end()
        if recipes.is_empty():
            push_warning("No recipes were loaded from path: " + recipes_path)
        return
    # If we failed to open the directory, print an error
    push_error("Failed to load recipes from path: " + recipes_path)

func _ready() -> void:
    #randomize rng and load recipes
    randomize()
    load_recipes()
func _process(_delta: float) -> void:

    # Check if day has started
    if day_started:
        # if we have no active timer, start one.
        if timer == 0:
            timer = pick_random_time()
        #iterate the accumulator and check if we have reached the timer to generate a new order
        accum += _delta
        if(accum >= timer):
            #create new order
            var order = new_order()
            if order:
                #add to pending orders and emit signal to update the UI
                pending_orders.append(order)
                update_orders_ui.emit(pending_orders)
            accum = 0.0
            timer = pick_random_time()
    
    # add a new order when the debug key is pressed for testing purposes
    if Input.is_action_just_released("debug_order"):
        var order = new_order()
        if order:
            pending_orders.append(order)
            update_orders_ui.emit(pending_orders)

# helper function to create a new order with a random recipe
func new_order() -> Order:
    var recipe = pick_random_recipe() # picks a random recipe from our collection
    if recipe:
        #create a new order instance
        var order = Order.new()
        #setup its fields
        order.recipe = recipe
        order.id = pending_orders.size() + completed_orders.size()
        return order
    push_warning("No recipes available to create an order.")
    return null

# helper function to print an order's details for debugging purposes
func print_order(order: Order , additional_info: String = "") -> void:
    print(additional_info + "\nOrder ID#: " + str(order.id) + "\n Status: " + str(order.status) + "\n Is Late: " + str(order.isLate) + "\n Recipe Name: " + order.recipe.result.Name + "\n Ingredients: ")
    for ingredient in order.recipe.ingredients:
        print("\n- " + ingredient.Name)

# mark an order as complete , remove it from the pending orders, and add it to our completed orders.
func complete_order(order:Order = null, id: int = -1) -> void:
    if order == null and id != -1:
        for o in pending_orders:
            if o.id == id:
                order = o
                break
    if order:
        pending_orders.erase(order)
        completed_orders.append(order)
        order.status = Order.OrderStatus.COMPLETED
        update_orders_ui.emit(pending_orders)
    else:
        push_warning("Order not found to complete." + str(id) + " " + str(order))
    pass

# mark an order as late
func mark_order_as_late(order:Order = null, id: int = -1) -> void:
    if order == null and id != -1:
        for o in pending_orders:
            if o.id == id:
                order = o
                break
    if order:
        order.isLate = true
        update_orders_ui.emit(pending_orders)
    else:
        push_warning("Order not found to mark as late." + str(id) + " " + str(order))

# set an order as active and all other orders as pending
func set_active_order(id: int) -> void:
    for o in pending_orders:
        if o.id == id:
            o.status = Order.OrderStatus.ACTIVE
            update_orders_ui.emit(pending_orders)
        if o.id != id and o.status == Order.OrderStatus.ACTIVE:
            o.status = Order.OrderStatus.PENDING
            update_orders_ui.emit(pending_orders)
    push_warning("Order not found to set as active: " + str(id))

# set an order as pending
func set_order_as_pending(id: int) -> void:
    for o in pending_orders:
        if o.id == id:
            o.status = Order.OrderStatus.PENDING
            update_orders_ui.emit(pending_orders)

#helper function to pick a random recipe
func pick_random_recipe() -> Recipe:
    if recipes.size() == 0:
        push_warning("No recipes available to pick from.")
        return null
    
    return recipes.pick_random()
#helper function to get all pending orders
func get_pending_orders() -> Array[Order]:
    return pending_orders
#helper function to get all completed orders
func get_completed_orders() -> Array[Order]:
    return completed_orders
#helper function to get the currently active order
func get_active_order() -> Order:
    for order in pending_orders:
        if order.status == Order.OrderStatus.ACTIVE:
            return order
    return null
# when timer reaches 8 am, start the day and generate some initial orders
func on_day_start() -> void:
    for i in range(2): # create 2 initial orders at the start of the day
        var order = new_order()
        if order:
            pending_orders.append(order)
    day_started = true
    update_orders_ui.emit(pending_orders)

