
class_name CharacterState


var _node: Node2D

func _init(node: Node2D):
	_node = node

@warning_ignore("unused_signal")
signal player_exited_from_screen()
@warning_ignore("unused_signal")
signal player_enter_on_screen()
#
# Character world position
#
@warning_ignore("unused_signal")
signal position_changed(value: Vector2)
var position: Vector2:
	get:
		return _node.position

var global_position: Vector2:
	get:
		return _node.global_position

#
# Target position where the character moves
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
var _properties: Dictionary = Dictionary():
	get:
		return _properties
	set(value):
		_properties = value
		properties_changed.emit(value)
		for prop in _properties.values():
			property_changed.emit(prop)


signal properties_changed(value: Dictionary)
signal property_changed(value: CharacterPropertyEntity)


func set_property(value: CharacterPropertyEntity):
	_properties[value.data_name] = value
	_node._save_properties_debounce.emit()
	property_changed.emit(value)


func get_property(name: String) -> CharacterPropertyEntity:
	return _properties.get(name, null)


func get_property_data(name: StringName) -> CharacterPropertyResource:
	var database := _node._resource_db.connection as Database
	return database.fetch_data("properties", name)
