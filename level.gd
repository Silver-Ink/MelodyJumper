class_name Level extends Node2D

var SC_level = preload("res://level.tscn")
var SC_fin = preload("res://ecran_de_fin.tscn")

func _ready():
	$PlayingArea/Player.level = self

func resart_game():
	var new_level = SC_level.instantiate()
	get_tree().root.add_child.call_deferred(new_level)
	queue_free.call_deferred()
	NotePlayer.init()
	
func game_over():
	var end = SC_fin.instantiate()
	end.level = self
	add_child(end)
	#get_tree().paused = true
