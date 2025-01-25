class_name NotePlayerClass extends Node


const _regular_db = -20.0
const _fadeout_db = -80.0

const _available_notes = ["a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "b0", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "d1", "d2", "d3", "d4", "d5", "d6", "d7", "e1", "e2", "e3", "e4", "e5", "e6", "e7", "f1", "f2", "f3", "f4", "f5", "f6", "f7", "g1", "g2", "g3", "g4", "g5", "g6", "g7"]


var _available_notes_dict = {}

var i = 60 #TEMP

# change the following dynamically to alter note lengths
var tempo = 60
var beats = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for note in _available_notes:
		_add_note_as_available(note)

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
	
	var hold_time:= _tempo_2_note_time(type)
	
	tween.tween_property(audio_player, "volume_db", _regular_db, hold_time)
	tween.tween_property(audio_player, "volume_db", _fadeout_db, hold_time / 4).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(audio_player.queue_free)

func _tempo_2_note_time(note_type: Note.Type) -> float:
	return ((float(tempo) / 60) * beats) / note_type
