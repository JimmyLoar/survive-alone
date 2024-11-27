class_name WorldObject
extends Area2D

signal character_entered
signal character_exited
signal character_changed_location

@export var data: StructureData:
	set(value):
		if data == value: return
		data = value
		_update()

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D




func _ready() -> void:
	name = "WorldObjec %s" % get_index()


func _char_entered(_char: Character):
	#print("player entered in '%s' in '%s'" % [self.name, get_parent().name])
	character_entered.emit()


func _char_exited(_char: Character):
	#print("player exited in '%s' in '%s'" % [self.name, get_parent().name])
	character_exited.emit()


func _update():
	if not data:
		_update_to_null()
		return
	
	if not sprite:
		sprite = $Sprite2D
		collision = $CollisionShape2D
	
	sprite.texture = data.texture
	collision.shape = data.collision_shape
	collision.position = data.collision_offset
	collision.rotation_degrees = data.collision_rotation


func _update_to_null():
	sprite.texture = null
	collision.shape = null
	collision.rotation = 0.0
