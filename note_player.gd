class_name NotePlayerClass extends Node


const _regular_db = -20.0
const _fadeout_db = -80.0

const _note_hold_time = 0.5
const _note_fadeout_time = 0.25

const _available_notes = ["a2", "a4", "b6"]


var _available_notes_dict = {}

var i = 60 #TEMP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for note in _available_notes:
		_add_note_as_available(note)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	i+=1
	if (i % 70 == 0):
		play_note(_available_notes[randi() % 3])
	pass

# Loads preemptively the sound file for a note
func _add_note_as_available(note_type: String):
	var piano_note = load("res://assets/samples/%s.wav" % note_type)
	
	if not piano_note:
		printerr("Error: Piano sample %s not found in samples directory" % note_type)
		return
	
	_available_notes_dict[note_type] = piano_note
	
# Plays the note requested, as long as it was made available beforehand
func play_note(note_type: String):
	if note_type not in _available_notes_dict:
		printerr("Error: Piano sample %s not available" % note_type)
		return
	
	var audio_player = AudioStreamPlayer.new()
	
	var piano_note = _available_notes_dict[note_type]
	
	# Playing note
	audio_player.stream = piano_note
	audio_player.volume_db = _regular_db
	
	add_child(audio_player)
	audio_player.play()
	
	# Handling note fadeout with a tween
	var tween = create_tween()
	
	tween.tween_property(audio_player, "volume_db", _regular_db, _note_hold_time)
	tween.tween_property(audio_player, "volume_db", _fadeout_db, _note_fadeout_time).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(audio_player.queue_free)
