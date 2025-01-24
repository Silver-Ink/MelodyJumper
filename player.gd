extends Node2D


var player_area
var current_pos = 2

var player_positions
var min_pos
var max_pos
@onready var animated_sprite_2d: AnimatedSprite2D = $Player_Area2D/AnimatedSprite2D

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

func _move_player(moving_up: bool):
	if ((moving_up && current_pos == min_pos) || (!moving_up && current_pos == max_pos)):
		return
	
	if (moving_up):
		_teleport_player(current_pos-1)
	else:
		_teleport_player(current_pos+1)

func _teleport_player(new_pos: int):
	if new_pos < 0 or new_pos >= player_positions.size():
		return
	
	player_area.position.y = player_positions[new_pos].position.y
	current_pos = new_pos
