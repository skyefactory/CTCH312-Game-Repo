extends Resource
class_name Recipe

@export var ingredients: Array[ItemData] # The ingredients required for this recipe, the order of the ingredients does not matter
@export var result: ItemData # The resulting item of this recipe, this is what the player will get after crafting this recipe