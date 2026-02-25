extends Area3D
class_name WorldItem
@export var item_data: ItemData # The item data of this world item, this will be used to determine what item this is when the player interacts with it
@export var quantity: int = 1 # The quantity of the item in this world item, this will be used to determine how many of the item the player picks up when they interact with it
