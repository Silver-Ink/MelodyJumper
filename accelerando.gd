class_name Accelerando extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var collider := area.get_parent()
	if (collider is not Player): return
	NotePlayer.accelerando()
	queue_free()
