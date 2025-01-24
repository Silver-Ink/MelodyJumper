class_name Shot extends Node2D

@export var speed := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	var collider = area.get_parent()
	if (collider is Note):
		queue_free()
