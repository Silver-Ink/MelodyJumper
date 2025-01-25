class_name Section extends Node2D

var is_first = false

var speed := 100
var reset_position : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= (float(speed * NotePlayer.tempo) / 60) * delta


func replace_to_end():
	position.x += reset_position
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	var collisionner = area.get_parent()
	if (area is ResetArea):
		replace_to_end()
