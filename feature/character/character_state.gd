class_name CharacterState
extends Injectable

var _node: Node2D


func _init(node: Node2D):
	_node = node


#
# Character world position
#
signal position_changed(value: Vector2)
var position: Vector2:
	get:
		return _node.position
	set(value):
		_node.position = value
		position_changed.emit(value)

#
# Target position where the character moves
#
var _target_postion: Vector2
signal target_position_changed(value: Vector2)
var target_position: Vector2:
	get:
		return _target_postion
	set(value):
		_target_postion = value
		target_position_changed.emit(value)

var is_moving: bool:
	get: return _target_postion != position


func reset_target(_delta):
	target_position = position


#
# Caracter properties
#
var _properties = Dictionary():
	get:
		return _properties
	set(value):
		_properties = value
		properties_changed.emit(value)
		for prop in _properties.values():
			property_changed.emit(prop)
signal properties_changed(value: Dictionary)
signal property_changed(value: CharacterPropertyResource)


func set_property(value: CharacterPropertyResource):
	_properties[value.name_key] = value
	property_changed.emit(value)


func get_property(name: String) -> CharacterPropertyResource:
	return _properties[name]
