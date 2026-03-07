extends RigidBody3D
class_name WorldItem


@export var Data: ItemData # The item data of this world item, this will be used to determine what item this is when the player interacts with it
@export var Quantity: int = 1 # The quantity of the item in this world item, this will be used to determine how many of the item the player picks up when they interact with it


@onready var player: Player = get_node("/root/Main/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_collision_exception_with(player) # prevents this rigidbody from colliding with the player, allowing the player to pass through it without physics interference.

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
			player.clear_interactable(self) # clear this item as the current interactable.
			if get_parent():
				get_parent().remove_child(self)
			queue_free()
		else: # if there is some remaining quantity, then we need to update this world item to reflect the remaining quantity
			Quantity = remaining
