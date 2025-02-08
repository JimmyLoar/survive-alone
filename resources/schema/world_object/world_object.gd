@tool
class_name WorldObjectResource
extends NamedResource

@export_group("Collision Shape", "collision")
@export var collision_shape: ConvexPolygonShape2D
@export var collision_offset := Vector2.ZERO
@export_range(-360, 360) var collision_rotation := 0.0:
	set(value):
		collision_rotation = wrapf(value, -360, 360)


func _init() -> void:
	super("STRUCTURE")
