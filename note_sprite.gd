class_name Note extends AnimatedSprite2D

enum Type {
	Ronde = 1,
	Blanche = 2,
	Noire = 4,
	Croche = 8,
	DoubleCroche = 16
}

@export var type: Type
@export var ligne: int = -1 # pas de ligne = pas de collision

var height = "a0"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		Type.Ronde:
			play("ronde_idle")
		Type.Blanche:
			play("blanche_idle")
		Type.Noire:
			play("noire_idle")
		Type.Croche:
			play("croche_idle")
		Type.DoubleCroche:
			play("double_croche_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	#if (ligne == -1): return
	var collider = area.get_parent()
	if (collider is PlayingArea):
		NotePlayer.play_note(height, type)
	elif (collider is Shot):
		queue_free()
		
