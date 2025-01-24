extends Node2D

var SC_section = preload("res://section.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func instanciate_sections():
	var section : Section = SC_section.instantiate()
	
	
	add_child(section)
