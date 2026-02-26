extends Control
class_name UIController

@export var inventory: Node
@export var blank_icon: Texture2D

@export var game_manager: GameManager

@onready var hotbar: ItemList = $Hotbar
@onready var daytimer_label: Label = $DayTimer
@onready var interact_label: Label = $InteractLabel
@onready var crosshair: ColorRect = $Crosshair

var daytimer: DayTimer


func _ready():
	daytimer = DayTimer.new()
	add_child(daytimer)
	daytimer.day_start.connect(on_day_start)
	daytimer.day_end.connect(on_day_end)
	daytimer.time_changed.connect(on_time_changed)

	inventory.inventory_changed.connect(update_hotbar)
	inventory.selected_item_changed.connect(highlight_slot)

	game_manager.game_paused.connect(on_game_paused)

	update_hotbar()

func update_hotbar():
	for i in range(inventory.inventory_size):
		if i >= hotbar.get_item_count(): # if there are not enough slots in the hotbar, add more
			hotbar.add_item(" ", blank_icon)
			hotbar.set_item_text(i, "0")
		var slot = inventory.slots[i]
		if slot.item == null:
			hotbar.set_item_icon(i, blank_icon)
			hotbar.set_item_text(i, "0")
		else:
			hotbar.set_item_icon(i, slot.item.Icon)
			if slot.item.MaxStackSize > 1:
				hotbar.set_item_text(i, str(slot.quantity))
			else:
				hotbar.set_item_text(i, "1")

func on_day_start():
	pass

func on_day_end():
	pass

func on_time_changed(hour: int, minute: int, pm: bool, spedup: bool):
	var display_hour = hour
	if display_hour == 0:
		display_hour = 12
	var am_pm = "PM" if pm else "AM"
	if spedup:
		daytimer_label.text = "%01d:%02d %s ▶▶" % [display_hour, minute, am_pm]
	else:
		daytimer_label.text = "%01d:%02d %s" % [display_hour, minute, am_pm]


func highlight_slot(index: int):
	hotbar.select(index)    

func on_game_paused():
	# show the pause menu
	pass
