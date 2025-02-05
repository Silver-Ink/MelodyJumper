class_name Note extends AnimatedSprite2D

enum Type {
	NULLNote = 0,
	Ronde = 1,
	Blanche = 2,
	Noire = 4,
	Croche = 8,
	DoubleCroche = 16
}

@export var type: Type = Type.NULLNote

var height = "c3"

var frames = 0
var has_collision = false

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
func _process(_delta: float) -> void:
	if (frames > 10):
		has_collision = true
	else:
		frames+=1

func _disapear():
	match type:
		Type.Ronde:
			play("ronde_disp")
		Type.Blanche:
			play("blanche_disp")
		Type.Noire:
			play("noire_disp")
		Type.Croche:
			play("croche_disp")
		Type.DoubleCroche:
			play("double_croche_disp")
	animation_finished.connect(queue_free)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not has_collision:
		return
	
	var collider = area.get_parent()
	if (collider is Shot or NotePlayer.game_over):
		var audio_player := AudioStreamPlayer2D.new()
		add_child(audio_player)
		audio_player.stream = load("res://assets/samples/P-36-SoftTp-A.wav")
		audio_player.play()
		_disapear()
		$Area2D.queue_free()
	elif (collider is PlayingArea):
		NotePlayer.play_note(height, type)
	elif(collider is Player):
		queue_free()
