extends Node

@onready var OrderPanel = $"../GUIPanel3D/SubViewport/GridContainer"
const OrderUIScene: PackedScene = preload("res://scenes/OrderOnScreenUI.tscn")

# List of all current orders in the game
var orders: Array[Order] = []

# First entry is the "base" recipe, second entry is the "variants"
var Recipies = [
	["Burger", ["Cheese", "Double", "Lettuce", "Silly Sauce"]]
]

# Keep track of the current active order
var active_order_id: int = -1

# ------------------------
# READY
# ------------------------
func _ready():
	#placeholder logic to setup initial orders for testing
	for i in range(3):
		#Creates a new order and adds it to the Orders list
		var order = createOrder()
		#Creates a new UI instance for this order to add it to the order panels
		var orderUIInstance = OrderUIScene.instantiate()
		
		# Get UI labels
		var baseLabel: RichTextLabel = orderUIInstance.get_child(2)
		var variationLabel: RichTextLabel = orderUIInstance.get_child(3)
		
		# Set label text directly from the Order object
		baseLabel.text = order.base
		variationLabel.text = ""
		#Go over each variation and append it to the variation label
		for j in range(order.variations.size()):
			variationLabel.text += str(order.variations[j])
			# add a comma if its not the last item.
			if j < order.variations.size() - 1:
				variationLabel.text += ", "

		#Add the new order UI instance into the order screen
		OrderPanel.add_child(orderUIInstance)

# ------------------------
# ORDER MANAGEMENT
# ------------------------

# Creates a new order and adds it to the orders list
func createOrder() -> Order:
	# Pick a recipe randomly
	var recipe = Recipies[randi() % Recipies.size()]
	
	# Pick random variations
	var num_variations = randi() % recipe[1].size() + 1
	var selected_variations: Array = []
	#Go through and add variations to the selected varionts.
	while selected_variations.size() < num_variations:
		#Make sure that no duplicate variations show up.
		var variation = recipe[1][randi() % recipe[1].size()]
		if variation not in selected_variations:
			selected_variations.append(variation)
	
	# Create Order object
	var order = Order.new(orders.size(), recipe[0], selected_variations)
	orders.append(order)
	return order

# Sets an order as active
func setActiveOrder(order_id: int) -> void:
	#Set the indicated ID as active, and clear any other previous active order
	for order in orders:
		if order.id == order_id:
			order.status = "active"
			active_order_id = order_id
		elif order.status == "active":
			order.status = "pending"

# Marks an order as complete
func completeOrder(order_id: int) -> void:
	for order in orders:
		if order.id == order_id:
			order.status = "completed"
			if active_order_id == order_id:
				active_order_id = -1

# Returns the currently active order
func getActiveOrder() -> Order:
	for order in orders:
		if order.status == "active":
			return order
	return null

# ------------------------
# UI / DEBUG
# ------------------------
func print_orders() -> void:
	print("---- Orders ----")
	for order in orders:
		print("ID:", order.id, "Status:", order.status, "Base:", order.base, "Variations:", order.variations)
	print("----------------")
