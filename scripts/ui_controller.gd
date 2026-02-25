extends Control

@export var inventory: Node
@export var hotbar: ItemList
@export var blank_icon: Texture2D

func _ready():
	inventory.inventory_changed.connect(update_hotbar)
	inventory.selected_item_changed.connect(highlight_slot)
	update_hotbar()

func update_hotbar():
	for i in range(inventory.inventory_size):
		var slot = inventory.slots[i]
		
		if slot.item == null:
			hotbar.set_item_icon(i, blank_icon)
			hotbar.set_item_text(i, "")
		else:
			hotbar.set_item_icon(i, slot.item.Icon)
			if slot.item.MaxStackSize > 1:
				hotbar.set_item_text(i, str(slot.quantity))
			else:
				hotbar.set_item_text(i, "")

func highlight_slot(index: int):
	hotbar.select(index)    