extends Area3D
class_name WorldItem


@export var Data: ItemData # The item data of this world item, this will be used to determine what item this is when the player interacts with it
@export var Quantity: int = 1 # The quantity of the item in this world item, this will be used to determine how many of the item the player picks up when they interact with it

var is_player_in_range: bool = false # whether the player is in range to pick up this item
var player: Player # reference to the player, used for adding the item to the player's inventory when they interact with it


func _ready() -> void:
	body_entered.connect(_on_body_entered) # connect the body entered signal to the function that checks if the player is in range
	body_exited.connect(_on_body_exited) # connect the body exited signal to the function that checks if the player is no longer in range

func _on_body_entered(body: Node) -> void:
	if body is Player: # check if the body that entered is the player
		is_player_in_range = true
		player = body
		player.set_interactable(self)
	

func _on_body_exited(body: Node) -> void:
	if body is Player: # check if the body that exited is the player
		is_player_in_range = false
		player.clear_interactable(self)
		player = null 

func can_interact(_interacting_player: Player) -> bool:
	return Data != null

func get_interaction_text(_interacting_player: Player) -> String:
	if Data:
		return "Press E to pick up %s" % Data.Name
	return "Press E to pick up"

func interact(_interacting_player: Player) -> void:
	pickup()

func pickup() -> void:
	if player and Data: # make sure there is a player reference and item data
		var remaining = player.inventory.add_inventory_item(Data, Quantity) # try to add the item to the player's inventory, this will return any remaining quantity that could not be added
		if remaining == 0: # if there is no remaining quantity, then we can remove this item from the world
			queue_free()
		else: # if there is some remaining quantity, then we need to update this world item to reflect the remaining quantity
			Quantity = remaining
