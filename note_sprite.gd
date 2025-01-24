extends Sprite2D

enum Type {
	Ronde = 1,
	Blanche = 2,
	Noire = 4,
	Croche = 8,
	DoubleCroche = 16
}

@export var type: Type
@export var ligne: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		Type.Ronde:
			set_texture(load("res://assets/sprites/Ronde.png"))
		Type.Blanche:
			set_texture(load("res://assets/sprites/blanche.png"))
		Type.Noire:
			set_texture(load("res://assets/sprites/noire.png"))
		Type.Croche:
			set_texture(load("res://assets/sprites/Croche.png"))
		Type.DoubleCroche:
			set_texture(load("res://assets/sprites/double croche.png"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
