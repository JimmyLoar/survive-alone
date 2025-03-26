@tool
class_name WorldObjectResource
extends NamedResource

@export_group("Collision Shape", "collision")
@export var collision_shape: ConvexPolygonShape2D

func _init() -> void:
	super("STRUCTURE")
