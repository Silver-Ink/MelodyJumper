class_name Player extends Node2D


var player_area
var current_pos = 2

var player_positions
var min_pos
var max_pos

var has_shield := false : set = _set_has_shield

var t_position_active := false
var t_position_start : Vector2
var t_position_dest : Vector2
var t_position_timer : float = 0.
var t_position_duration : float = .12


@onready var animated_sprite_2d: AnimatedSprite2D = $Player_Area2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var SC_shot = preload("res://shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_area = get_node("Player_Area2D")
	
	player_positions = get_children()
	player_positions = player_positions.filter(func(node): return node is Marker2D)
	player_positions.sort_custom(func(node1, node2): return (node1.position.y < node2.position.y))
	min_pos = 0
	max_pos = player_positions.size()-1
	animated_sprite_2d.play("idle")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_down")):
		_move_player(false)
	elif (Input.is_action_just_pressed("ui_up")):
		_move_player(true)
	
	if (Input.is_action_just_pressed("ui_accept")):
		_shot_natural()
		
	if (t_position_active):
		player_area.position = tween_position()
		t_position_timer += delta
		if (t_position_timer > t_position_duration):
			t_position_active = false

func _move_player(moving_up: bool):
	if ((moving_up && current_pos == min_pos) || (!moving_up && current_pos == max_pos)):
		return
	
	if (moving_up):
		_set_player_position(current_pos-1)
	else:
		_set_player_position(current_pos+1)

func _set_player_position(new_pos: int):
	if new_pos < 0 or new_pos >= player_positions.size():
		return
	
	t_position_start = player_area.position
	t_position_dest = player_positions[new_pos].position
	current_pos = new_pos
	t_position_active = true
	t_position_timer = 0.
	
func _shot_natural():
	animated_sprite_2d.play("shoot")
	animation_player.play("pulse")
	
	var new_shot : Shot = SC_shot.instantiate()
	var pos = animated_sprite_2d.global_position.y
	new_shot.global_position.y = pos
	
	add_child(new_shot)
	
func _set_has_shield(value : bool):
	has_shield = value
	$Player_Area2D/Shield.visible = value
	
func _on_player_area_2d_area_entered(area: Area2D) -> void:
	var collider = area.get_parent()
	if (collider is Fermata):
		has_shield = true
	elif (collider is Note):
		if (has_shield):
			animation_player.play("pulse")
			has_shield = false
		else:
			_gameover()


func _gameover():
	print("perdu")
	queue_free()
	
func tween_position():
	return Tween.interpolate_value(
				t_position_start,
				t_position_dest - t_position_start,
				t_position_timer,
				t_position_duration,
				Tween.TRANS_QUINT,
				Tween.EASE_OUT )
