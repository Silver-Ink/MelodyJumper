extends Node2D

@export var length := 3

var SC_section = preload("res://section.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_sections()


func instantiate_sections():
	var example_section : Section = SC_section.instantiate()
	var shape : CollisionShape2D = example_section.get_node("Area2D/CollisionShape2D")
	var rect : RectangleShape2D
	var width : float
	
	var origin : Marker2D = get_node("Marker2D")
	if (!is_instance_valid(origin)):
		printerr("Erreur: pas de marker2d en enfant de la track !")
	
	if (!is_instance_valid(shape)):
		printerr("Erreur: lecture de la node collisionshape")
		
	rect = shape.shape
	if (!is_instance_valid(rect)):
		printerr("Erreur: accès de la RectangleShape")
	width = rect.size.x
	
	for i in range(length):
		var section : Section = SC_section.instantiate()
		add_child(section)
		
		section.position = origin.position
		
		var offset = i * width + width / 2.
		section.position.x += offset
		section.reset_position = int(length * width)

		if (i == 0):
			section.is_first = true
			
			var sprite = Sprite2D.new()
			sprite.texture = load("res://assets/sprites/section_bar.png")
			sprite.scale.y = 100 
			sprite.z_index = -4000
			section.add_child(sprite)
		
	example_section.queue_free()
