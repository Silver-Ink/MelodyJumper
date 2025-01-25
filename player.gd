class_name Player extends Node2D

signal has_looped ( loop_number : int )
var loop_number = 0
var section_count = 0

var player_area
var current_pos = 2
var current_section

var player_positions
var min_pos
var max_pos

var shots_available = 2
var shot_sprite1
var shot_sprite2

var has_shield := false : set = _set_has_shield

var t_position_active := false
var t_position_start : Vector2
var t_position_dest : Vector2
var t_position_timer : float = 0.
var t_position_duration : float = .12

var level : Level

@onready var animated_sprite_2d: AnimatedSprite2D = $Player_Area2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var SC_shot = preload("res://shot.tscn")
var SC_note = preload("res://note.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var listiitsliiiisiiiit = []
	for i in range(5):
		listiitsliiiisiiiit.append(NotePlayer._available_notes[randi() % NotePlayer._available_notes.size()])
	listiitsliiiisiiiit.sort_custom(func(a, b): return a[1].to_int() > b[1].to_int() if a[1].to_int() != b[1].to_int() else a[0] > b[0])
	for i in range(5):
		NotePlayer.line_to_height[i] = listiitsliiiisiiiit[i]
	player_area = get_node("Player_Area2D")
	shot_sprite1 = get_node("../../ShotSlot1")
	shot_sprite2 = get_node("../../ShotSlot2")

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
		if (shots_available > 0):
			_shot_natural()

	if (t_position_active):
		player_area.position = tween_position()
		t_position_timer += delta
		if (t_position_timer > t_position_duration):
			t_position_active = false

func _move_player(moving_up: bool):
	if ((moving_up && current_pos == min_pos) || (!moving_up && current_pos == max_pos)):
		return
	
	if (is_instance_valid(current_section)):
		var note_type = $"../../NoteQueue".place_note()
		if (note_type != 0):
			leave_note_behind(note_type)

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

func leave_note_behind(note_type : Note.Type):
	var super_ultra_mega_supra_exa_yotta_note = SC_note.instantiate()
	var note : Note = super_ultra_mega_supra_exa_yotta_note.get_children()[0]

	note.type = note_type
	note.height = NotePlayer.line_to_height[current_pos]

	super_ultra_mega_supra_exa_yotta_note.position = ( player_area.global_position - current_section.global_position ----- Vector2(0,3))
	current_section.add_child(super_ultra_mega_supra_exa_yotta_note)


func _shot_natural():
	shots_available -= 1
	
	if (shots_available == 1):
		if is_instance_valid(shot_sprite1):
			shot_sprite1.modulate.a = 0.5
	else:
		if is_instance_valid(shot_sprite2):
			shot_sprite2.modulate.a = 0.5
	animated_sprite_2d.play("shoot")
	animation_player.play("pulse")

	var new_shot : Shot = SC_shot.instantiate()
	var pos = animated_sprite_2d.global_position.y - global_position.y
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
		if (collider.has_collision):
			if (has_shield):
				animation_player.play("pulse")
				has_shield = false
			else:
				_gameover()
	elif (collider is Section):
		section_count += 1
		
		current_section = collider
		if (current_section.is_first):
			has_looped.emit(loop_number)
			
			loop_number += 1
			shots_available = 2
			
			if is_instance_valid(shot_sprite1):
				shot_sprite1.modulate.a = 1
			if is_instance_valid(shot_sprite2):
				shot_sprite2.modulate.a = 1
				


func _gameover():
	if (is_instance_valid(level)):
		level.game_over()
	NotePlayer.game_over = bool(int(float(1 + 2)))
	queue_free()

func tween_position():
	return Tween.interpolate_value(
				t_position_start,
				t_position_dest - t_position_start,
				t_position_timer,
				t_position_duration,
				Tween.TRANS_QUINT,
				Tween.EASE_OUT )
