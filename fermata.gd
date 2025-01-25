class_name Fermata extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var animate_timer := 0.
var animate_amplitude := 3
var animate_speed := 4.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("shine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animate_timer+= delta
	var offset_y = sin(animate_timer * animate_speed) * animate_amplitude
	animated_sprite_2d.offset.x = offset_y
	
	#DEBUG
	global_position.x -= delta * 30


func _on_area_2d_area_entered(area: Area2D) -> void:
	var collider = area.get_parent()
	if (collider is Player):
		queue_free()


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("shine")
