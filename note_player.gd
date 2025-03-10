class_name NotePlayerClass extends Node


const _regular_db = -20.0
const _fadeout_db = -80.0

const _initial_tempo: float = 60.0

const _available_notes = ["a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "b0", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "d1", "d2", "d3", "d4", "d5", "d6", "d7", "e1", "e2", "e3", "e4", "e5", "e6", "e7", "f1", "f2", "f3", "f4", "f5", "f6", "f7", "g1", "g2", "g3", "g4", "g5", "g6", "g7"]

const _accel_slowdown_threshold := 25
const _accel_stop_threshold := 50

var _accel_ref: Timer
var _accel_count := 0

var _available_notes_dict = {}

# Change the following dynamically to alter note lengths
var tempo: float = _initial_tempo
var beats: int = 4

var game_over = false

var line_to_height = {0: "c4", 1: "e4", 2: "g4", 3: "b5", 4: "d5"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for note in _available_notes:
		_add_note_as_available(note)
	init()

# Initializes the NotePlayer every time a run is started.
func init():
	game_over = false
	tempo = _initial_tempo
	
	# Stop and destroy timer object if it was created in the previous run
	if (_accel_ref):
		_accel_ref.stop()
		_accel_ref.queue_free()
		_accel_ref = null

# Loads preemptively the sound file for a note
func _add_note_as_available(note_type: String):
	var piano_note = load("res://assets/samples/%s.wav" % note_type)
	
	if not piano_note:
		printerr("Error: Piano sample %s not found in samples directory" % note_type)
		return
	
	_available_notes_dict[note_type] = piano_note
	
# Plays the note requested, as long as it was made available beforehand
func play_note(height: String, type: Note.Type):
	if height not in _available_notes_dict:
		printerr("Error: Piano key %s not available" % height)
		return
	
	var audio_player = AudioStreamPlayer.new()
	
	var piano_note = _available_notes_dict[height]
	
	# Playing note
	audio_player.stream = piano_note
	audio_player.volume_db = _regular_db
	
	add_child(audio_player)
	audio_player.play()
	
	# Handling note fadeout with a tween
	var tween = create_tween()
	
	tween.tween_property(audio_player, "volume_db", _regular_db, _tempo_2_note_time(type))
	tween.tween_property(audio_player, "volume_db", _fadeout_db, 0.25).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(audio_player.queue_free)

func _tempo_2_note_time(note_type: Note.Type) -> float:
	return ((tempo / 60) * beats) / note_type

# Starts the 
func accelerando():
	_accel_ref = Timer.new()
	add_child(_accel_ref)
	
	_accel_ref.wait_time = beats
	_accel_ref.connect("timeout", _on_timer_accelerando)
	
	_accel_ref.start()

func _on_timer_accelerando():
	_accel_count += 1
	
	if _accel_count > _accel_stop_threshold:
		_accel_ref.stop()
	elif _accel_count > _accel_slowdown_threshold:
		tempo += 1
	else:
		tempo += 2
