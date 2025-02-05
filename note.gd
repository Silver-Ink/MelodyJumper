class_name NoteScene extends Node2D

func get_note_sprite() -> Note:
	return get_child(0) as Note
