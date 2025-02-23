@tool
class_name EffectResource
extends Resource

var name := "":
	set(value):
		name = value
		if name != "":
			args.resize(CondisionsAndEffects.get_effect_arg_types(name).size())
		else: 
			args.resize(0)
		notify_property_list_changed()

var args: Array = []

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var property: Dictionary = PropertyGenerater.take_string("name")
	var _names := CondisionsAndEffects.get_effect_names()
	properties.append(PropertyGenerater.convert_to_enum(property, ",".join(_names), false))
	if name != "": 
		var types := CondisionsAndEffects.get_effect_arg_types(name)
		for i in types.size():
			property = _get_arg_property(types[i], "arg_%d" % i)
			properties.append(property)
	return properties


func _get_arg_property(type: String, _name: String):
	match type:
		"String":	return PropertyGenerater.take_string(_name)
		"int":		return PropertyGenerater.take_int(_name)
		
		var key when key.begins_with("enum"): 
			var property: Dictionary = PropertyGenerater.take_int(_name)
			return PropertyGenerater.convert_to_enum(
				property, type.get_slice("/", 2), type.get_slice("/", 1) == "int"
			)
		
		var key when key.begins_with("Resource"): 
			return PropertyGenerater.take_resource(_name, type.get_slice("/", 1))
		
		_: return {}


func _set(property: StringName, value: Variant) -> bool:
	if name != "":
		if property.begins_with("arg"):
			var index: int = property.to_int()
			args[index] = value
			return true
	return false


func _get(property: StringName):
	if name != "":
		if property.begins_with("arg"):
			var index: int = property.to_int()
			return args[index]


func _property_get_revert(property: StringName) -> Variant:
	if name != "":
		if property.begins_with("arg"):
			var index: int = property.to_int()
			return CondisionsAndEffects.get_effect_args_default(name)[index]
	return null
