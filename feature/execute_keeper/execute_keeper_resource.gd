@tool
class_name ExecuteKeeperResource 
extends Resource

const TYPE_CONDITION	= ExecuteKeeperState.TYPE_CONDITION
const TYPE_EFFECT		= ExecuteKeeperState.TYPE_EFFECT

var type: String = ExecuteKeeperState._types[0]:
	set(value):
		type = value 
		_update_names()


var name: String : set = set_method_name
var _names: PackedStringArray = ExecuteKeeperState.get_names(self.type)

var args_data: Array = []
var _args_types: Array = []


func set_method_name(new_name: String):
	#printerr("new_name: " + new_name)
	name = new_name if new_name != "" else ExecuteKeeperState.NONE_NAME
	_args_types = ExecuteKeeperState.get_args(self.type, name)
	args_data.resize(_args_types[0].size())
	_update_names()
	notify_property_list_changed()


func _update_names():
	if Engine.is_editor_hint():
		_names = ExecuteKeeperState.get_names(self.type)
		if _names.size() == 0:
			_names.append("")


func get_type_values() -> Array:
	return _args_types[0]


func get_default_values() -> Array:
	return _args_types[1]


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var property: Dictionary = PropertyGenerater.take_string("type")
	properties.append(PropertyGenerater.convert_to_enum(property, ",".join(ExecuteKeeperState._types), false))
	if type == "":
		return properties
	
	property = PropertyGenerater.take_string("name")
	properties.append(PropertyGenerater.convert_to_enum(property, ",".join(_names), false))
	if name != "": 
		var types := get_type_values()
		for i in types.size():
			property = _get_arg_property(types[i], "arg_%d" % i)
			properties.append(property)
	return properties


func _get_arg_property(arg_type: String, _name: String):
	match arg_type:
		var key when key.begins_with("String"): 
			var hints = key.split("/")
			return PropertyGenerater.take_string(_name, 
				hints.has(str(PROPERTY_HINT_MULTILINE_TEXT)), 
				hints.has(str(PROPERTY_USAGE_READ_ONLY))
			)
		
		"int":
			return PropertyGenerater.take_int(_name)
		
		var key when key.begins_with("enum"): 
			var property: Dictionary = PropertyGenerater.take_int(_name)
			return PropertyGenerater.convert_to_enum(
				property, arg_type.get_slice("/", 2), arg_type.get_slice("/", 1) == "int"
			)
		
		var key when key.begins_with("Resource"): 
			return PropertyGenerater.take_resource(_name, arg_type.get_slice("/", 1))
		
		_: return {
			"name": _name,
			"type": TYPE_NIL,
		}


func _set(property: StringName, value: Variant) -> bool:
	if name != "":
		if property.begins_with("arg"):
			var index: int = property.to_int()
			if index >= args_data.size():
				args_data.resize(index + 1)
			args_data[index] = value
			return true
	return false


func _get(property: StringName):
	if name != "":
		if property.begins_with("arg"):
			var index: int = property.to_int()
			var value = args_data[index]
			return value if value else _property_get_revert(property)


func _property_get_revert(property: StringName) -> Variant:
	if name != "":
		if property.begins_with("arg"):
			var index: int = property.to_int()
			return get_default_values()[index]
	return null
