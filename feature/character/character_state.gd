class_name CharacterState
extends Injectable

var _node: Node2D

func _init(node: Node2D):
	_node = node


signal player_exited_from_screen()
signal player_enter_on_screen()
#
# Character world position
#
signal position_changed(value: Vector2)
var position: Vector2:
	get:
		return _node.position

var global_position: Vector2:
	get:
		return _node.global_position

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


func stop_moving():
	reset_target(null)

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
		_node._save_properties_debounce.emit()
		for prop in _properties.values():
			property_changed.emit(prop)


signal properties_changed(value: Dictionary)
signal property_changed(value: CharacterPropertyResource)


func set_property(value: CharacterPropertyResource):
	_properties[value.code_name] = value
	_node._save_properties_debounce.emit()
	property_changed.emit(value)


func get_property(name: String) -> CharacterPropertyResource:
	return _properties.get(name, null)
