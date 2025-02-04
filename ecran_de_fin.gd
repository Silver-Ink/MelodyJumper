extends CanvasLayer

var level : Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_released("ui_accept")):
		_on_retry_button_up()


func _on_retry_button_up() -> void:
	level.restart_game()
