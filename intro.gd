extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var start_button: TextureButton = $TextureButton

var start := false

var SC_level = preload("res://level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")
	audio_stream_player_2d.play()
	animated_sprite_2d.animation_finished.connect(on_intro_finished)
	start_button.visible = false

func on_intro_finished():
	start_button.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_released("ui_accept") or start):
		var new_level = SC_level.instantiate()
		get_tree().root.add_child.call_deferred(new_level)
		queue_free.call_deferred()


func _on_texture_button_button_up() -> void:
	start = true
