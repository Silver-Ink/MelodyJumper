class_name Section extends Node2D

var is_first = false

var speed := 100
var reset_position : int

var SC_note := preload("res://note.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var number_of_notes_gerenated: int = randi() % 3
	for i in range(number_of_notes_gerenated):
		var super_new_note: Node2D = SC_note.instantiate()
		var new_note: Note = super_new_note.get_children()[0]
		
		new_note.type = 2**(randi() % 5) as Note.Type
		var line: int = 4 - (randi() % 5)
		new_note.height = NotePlayer.line_to_height[line]
		line += 1
		super_new_note.position.x = randi() % 35 * (1 if randi() % 2 == 0 else -1)
		super_new_note.position.y = (line - 3) * -14 - 3
		add_child(super_new_note)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= (float(speed * NotePlayer.tempo) / 60) * delta


func replace_to_end():
	position.x += reset_position


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area is ResetArea):
		replace_to_end()
