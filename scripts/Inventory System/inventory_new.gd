extends Node

var slots: Array[InventorySlot] = [] # The inventory slots of the player, this will be used to store the items in the player's inventory
var inventory_size: int = 9 # size of inventory
var selected_slot: int = -1 # current selected item in item list
@export var hotbar: ItemList # reference to the item list
@export var blank_icon: Texture2D # blank icon for empty inventory slots

func _ready() -> void:
    for i in inventory_size:
        var slot = InventorySlot.new()
        slots.append(slot)
        hotbar.add_item(" ", blank_icon)

func _process(_delta: float) -> void:
    pass

func add_inventory_item(item: ItemData, quantity: int) -> bool:
    if item == null or quantity <= 0: return false
    var can_item_be_added: bool = false;

func add_item_to_stack(item: WorldItem) -> bool:
    if item == null or item.Quantity <= 0: return false
    var can_item_be_added: bool = false;

    if item.item_data.MaxStackSize > 1:
        for slot in inventory_size:
            #check if the slot is empty, if it is empty continue to next slot
            if slots[slot].item == null: 
                continue
            #check if the item in the slot is the same as the item we are trying to add, 
            #if it is not the same continue to next slot
            if slots[slot].item.ID != item.item_data.ID:
                continue
            #check if the slot is already full, if it is full continue to next slot
            if slots[slot].quantity >= item.item_data.MaxStackSize:
                continue
            #check if adding the item to the slot would exceed the max stack size, 
            #if it would exceed the max stack size add as much as possible to the slot 
            #and reduce the quantity of the item we are trying to add by the amount 
            #we added to the slot
            if slots[slot].quantity + item.Quantity > item.item_data.MaxStackSize:
                var amount_to_add: int = item.item_data.MaxStackSize - slots[slot].quantity
                slots[slot].quantity += amount_to_add
                item.Quantity -= amount_to_add
                can_item_be_added = true
                hotbar.set_item_text(slot, str(slots[slot].quantity))
                continue

                