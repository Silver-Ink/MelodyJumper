class_name Accelerando extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_area_2d_area_entered(Area2D.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var collider := area.get_parent()
	if (collider is not Player): return
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = NotePlayer.beats
	timer.start()
	timer.connect("timeout", _on_timer_accelerando)
	queue_free()

func _on_timer_accelerando():
	NotePlayer.tempo += 10
