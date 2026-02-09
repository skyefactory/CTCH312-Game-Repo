extends Node
@onready var OrderPanel = $"../GUIPanel3D/SubViewport/GridContainer"
const OrderUIScene: PackedScene = preload("res://scenes/OrderOnScreenUI.tscn")
# List of all current orders in the game
var orders: Array = []

# First entry is the "base" recipe, second entry is the "variants"
var Recipies = [
	["Burger", ["Cheese", "Double", "Lettuce", "Silly Sauce"]]
]

# Keep track of the current active order
var active_order_id: int = -1

func _ready():

	for i in range(3):
		createOrder()
		var orderUIInstance = OrderUIScene.instantiate()
		OrderPanel.add_child(orderUIInstance)
	print(OrderPanel.get_children())
	print_orders()

# ------------------------
# ORDER MANAGEMENT
# ------------------------

# Creates a new order and adds it to the orders list
func createOrder() -> int:
	var new_order = placeOrder()
	var order_data = {
		"ID": orders.size(),
		"Items": new_order,
		"Status": "pending" # can be "pending", "active", "completed"
	}
	orders.append(order_data)
	return order_data["ID"]

# Generates the random items for an order
func placeOrder() -> Array:
	var order: Array = []
	var numItems = randi() % 2
	
	for i in range(numItems):
		var recipe_index = randi() % Recipies.size()
		var recipe = Recipies[recipe_index]
		
		# Decide how many variations this item will have (1 to all available)
		var num_variations = randi() % recipe[1].size() + 1
		var selected_variations: Array = []
		var used_indices: Array = []
		
		while selected_variations.size() < num_variations:
			var variation_index = randi() % recipe[1].size()
			if variation_index not in used_indices:
				selected_variations.append(recipe[1][variation_index])
				used_indices.append(variation_index)
		
		order.append({
			"Base": recipe[0],
			"Variations": selected_variations
		})
	
	return order


# Sets an order as active
func setActiveOrder(order_id: int) -> void:
	for order in orders:
		if order["ID"] == order_id:
			order["Status"] = "active"
			active_order_id = order_id
		elif order["Status"] == "active":
			order["Status"] = "pending"

# Marks an order as complete
func completeOrder(order_id: int) -> void:
	for order in orders:
		if order["ID"] == order_id:
			order["Status"] = "completed"
			if active_order_id == order_id:
				active_order_id = -1

# Returns the currently active order
func getActiveOrder() -> Dictionary:
	for order in orders:
		if order["Status"] == "active":
			return order
	return {}

# ------------------------
# UI / DEBUG
# ------------------------

# Prints all orders to the console
func print_orders() -> void:
	print("---- Orders ----")
	for order in orders:
		print("ID:", order["ID"], "Status:", order["Status"], "Items:", order["Items"])
	print("----------------")
