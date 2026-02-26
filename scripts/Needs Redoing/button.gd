extends Button
@onready var rect: ColorRect = $"../ColorRect"
var ID: Node

var OrderManager:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OrderManager = $"../../../../../OrderManager"
	ID = $"../".get_child(4);

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_toggled(toggled_on: bool) -> void:
	
	if(!toggled_on): rect.color = Color(255, 0.0, 0.0, 1.0)
	else: 
		rect.color = Color(0.0, 155, 0.0, 1.0)
		OrderManager.setActiveOrder(int(ID.name))
		var order = OrderManager.getActiveOrder()
		print("ID:", order.id, " Status:", order.status, " Base:", order.base, " Variations:", order.variations)
	pass # Replace with function body.


func _on_timer_finished() -> void:
	OrderManager.setOrderAsLate(int(ID.name))
	pass # Replace with function body.
