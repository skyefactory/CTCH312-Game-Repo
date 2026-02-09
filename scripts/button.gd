extends Button
@onready var rect: ColorRect = $"../ColorRect"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_toggled(toggled_on: bool) -> void:
	print(toggled)
	if(!toggled_on): rect.color = Color(255, 0.0, 0.0, 1.0)
	else: rect.color = Color(0.0, 155, 0.0, 1.0)
	pass # Replace with function body.
