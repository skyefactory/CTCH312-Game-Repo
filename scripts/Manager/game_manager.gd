extends Node
class_name GameManager

signal game_paused

func _process(_delta: float) -> void:
    if Input.is_action_pressed("pause"):
        pause_game()

func pause_game():
    get_tree().paused = true
    game_paused.emit()