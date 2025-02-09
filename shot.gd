class_name Shot extends Node2D

@export var speed := 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const _shot_lasting_time := 0.8
const _shot_disappearing_time := 0.1

var _active := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("becarre_aura")
	get_tree().create_timer(_shot_lasting_time).timeout.connect(_deactivate_shot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (_active):
		position.x += speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (!_active):
		return
		
	var collider = area.get_parent()
	if (collider is Note):
		queue_free()

func _deactivate_shot():
	_active = false
	animated_sprite_2d.play("becarre_disappear")
	
	get_tree().create_timer(_shot_disappearing_time).timeout.connect(queue_free)
