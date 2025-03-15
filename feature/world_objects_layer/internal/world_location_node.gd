class_name WorldLocationNode
extends Area2D

@export var resource: WorldLocationResource
@onready var _sprite = %Sprite

func _ready() -> void:
	_sprite.texture = resource.texture
