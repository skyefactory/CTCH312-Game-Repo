extends Node

var slots: Array[InventorySlot] = [] # The inventory slots of the player, this will be used to store the items in the player's inventory
var inventory_size: int = 9 # size of inventory
var selected_slot: int = -1 # current selected item in item list
@export var player: Node3D # reference to the player node for dropping items in the world
signal inventory_changed
signal selected_item_changed
var held_item: InventorySlot
func _ready() -> void:
    for i in range(inventory_size):
        var slot = InventorySlot.new()
        slots.append(slot)
        emit_signal("inventory_changed")

func _process(_delta: float) -> void:
    handle_slot_input()
    if selected_slot >=0 and selected_slot < inventory_size:
        held_item = slots[selected_slot]
    pass

func handle_slot_input() -> void:
    for i in range(inventory_size):
        if Input.is_action_just_pressed("slot_" + str(i+1)):
            selected_slot = i
            emit_signal("selected_item_changed", selected_slot)

func remove_selected_item() -> InventorySlot:
    if selected_slot < 0:
        return null
		
    var slot = slots[selected_slot]
    if slot.item == null:
        return null
		
    var removed = slot
    slots[selected_slot] = InventorySlot.new()
	
    emit_signal("inventory_changed")
    return removed

func add_inventory_item(item: ItemData, quantity: int) -> int:
    assert(item != null and quantity > 0,
        "Invalid item or quantity")
    var remaining: int = quantity
    remaining = add_item_to_stack(item, remaining)

    if remaining <= 0:
        return 0
    for slot in range(inventory_size):
        if slots[slot].item != null: continue

        slots[slot].item = item
        slots[slot].quantity = remaining
        emit_signal("inventory_changed")
        return 0
    return remaining

func add_item_to_stack(item: ItemData, quantity: int) -> int:
    assert(item != null and quantity > 0,
        "Invalid item or quantity")
    var remaining: int = quantity

    if item.MaxStackSize > 1:
        for slot in range(inventory_size):
            if slots[slot].item == null: 
                continue
            if slots[slot].item.ID != item.ID:
                continue
            if slots[slot].quantity >= item.MaxStackSize:
                continue
            
            if slots[slot].quantity + remaining > item.MaxStackSize:
                var amount_to_add: int = item.MaxStackSize - slots[slot].quantity
                slots[slot].quantity += amount_to_add
                remaining -= amount_to_add
                emit_signal("inventory_changed")
                continue
            
            slots[slot].quantity += remaining
            remaining = 0
            emit_signal("inventory_changed")
            break

    return remaining
