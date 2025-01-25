extends Node2D

const _visible_queue_size = 3
const _queue_size = 100

const _next_note_cooldown = 1.0

const _short_notes_weight = 0.6
const _short_medium_notes_weight = 0.9

var queue = []
var current_note = 0

var next_note : Sprite2D
var queue_positions

var can_use_note = true

var SC_note = preload("res://note.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_note = get_node("NextNote")
	
	queue_positions = get_children()
	queue_positions = queue_positions.filter(func(node): return node is Marker2D)
	queue_positions.sort_custom(func(node1, node2): return (node1.position.x < node2.position.x))
	
	regenerate_queue()
	
	_update_queue_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func regenerate_queue():
	queue = []
	current_note = 0
	
	for i in range(_queue_size):
		var random_float = randf()
		
		var note_scene = SC_note.instantiate()
		var note : Note = note_scene.get_children()[0]
		
		if (random_float < _short_notes_weight):
			note.type = Note.Type.Croche if (randi() % 2 == 0) else Note.Type.DoubleCroche
		elif (random_float < _short_medium_notes_weight):
			note.type = Note.Type.Noire
		else:
			note.type = Note.Type.Blanche if (randi() % 2 == 0) else Note.Type.Ronde
		
		note_scene.position = Vector2(-10000, -10000)
		queue.append(note_scene)
		add_child(note_scene)

func _update_queue_ui():
	if queue.size() == 0:
		return
		
	queue[0].position = next_note.position
	
	var i = 0
	while (i < _visible_queue_size && i < queue.size()-1):
		queue[i+1].position = queue_positions[i].position
		i+=1

func place_note() -> Note.Type :
	if (queue.size() == 0 or not can_use_note):
		return 0
	
	can_use_note = false
	next_note.modulate = Color.RED # placeholder for anim
	
	# Freeing next note sprite and keeping its value for return
	var note_to_remove = queue.pop_front()
	var note_type = note_to_remove.get_children()[0].type
	note_to_remove.queue_free()
	
	get_tree().create_timer(_next_note_cooldown).timeout.connect(_on_timer_finished)
	
	return note_type
	
func _on_timer_finished():
	next_note.modulate = Color.WHITE
	
	_update_queue_ui()
	can_use_note = true
