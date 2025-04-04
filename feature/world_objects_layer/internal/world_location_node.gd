class_name WorldLocationNode
extends Node2D

@export var resource: WorldLocationResource
@export var show_collision_shape: bool
@export var events: EventSelecter

@onready var _sprite = %Sprite

func _ready() -> void:
	_sprite.texture = resource.texture
	
	if show_collision_shape:
		var line = Line2D.new()
		
		for point in resource.collision_shape.points:
			line.add_point(point)
		line.closed = true
		line.width = 2
		line.default_color = Color.RED
		add_child(line)
