extends Node3D
@export var hasTicket: bool
@onready var ticketPickupPrompt = $ticketpickup

func _on_trigger_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Players"):
			ticketPickupPrompt.text = "Press 'E' to pickup ticket."

func _on_trigger_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Players"):
		ticketPickupPrompt.text = ""
