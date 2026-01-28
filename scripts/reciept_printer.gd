extends Node3D
@export var hasTicket: bool
@onready var ticketPickupPrompt = $ticketpickup
var orders = []
#First entry is the "base" recipie, second entry is the "variant", need to pick
var Recipies = [
	["Burger", ["Cheese", "Normal", "Double"]],
	["Beer", ["Corona", "Budweiser", "Coors Light"]]
]

func _ready():
	var myOrder = placeOrder()
	orders.append({
		"ID": orders.size(),
		"Order": myOrder
	})
	print(orders)


func placeOrder() -> Array:
	var order = [] #holds the order
	
	var numItems = randi() % 3 + 1 #number of items in this order
	
	for i in range(numItems):
		var recipe_index = randi() % Recipies.size()
		var recipe = Recipies[recipe_index]
		
		var variation_index = randi() % recipe[1].size()
		var variation = recipe[1][variation_index]
		
		order.append({
			"Base": recipe[0],
			"Variation": variation
		})
		
	return order

func _on_trigger_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Players"):
			ticketPickupPrompt.text = "Press 'E' to pickup ticket."

func _on_trigger_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Players"):
		ticketPickupPrompt.text = ""
