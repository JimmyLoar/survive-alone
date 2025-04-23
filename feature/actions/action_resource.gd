@tool
class_name Action
extends Resource

var _action_methods := preload("res://feature/actions/custom_methods.gd").new()


var _method_name: String = '':
	set(value):
		_method_name = value
		_args.resize(_action_methods.get_method_argument_count(_method_name))
		notify_property_list_changed()


var _args : Array = []


func execute() -> Variant:
	return _action_methods.callv(_method_name, _args)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append(_service_methods())
	properties.append_array(_service_args())
	return properties


func _service_methods():
	var property = PropertyGenerater.take_string("_method_name")
	var _methods = _action_methods.get_script().get_script_method_list().filter(
		func(elm):
			return not (elm.name.begins_with("_") 
				or elm.name.begins_with("@")
			)
	)
	_methods = _methods.map(func(elm): return elm.name)
	return PropertyGenerater.convert_to_enum(property, ",".join(_methods))


func _service_args() -> Array:
	var methods = _action_methods.get_script().get_script_method_list() as Array
	var method_id = methods.find_custom(func(elm): return elm.name == _method_name)
	var args = methods[method_id].args
	var _index = 0
	for elm in args:
		elm.usage = PROPERTY_USAGE_DEFAULT
		elm.name = "arg_%d_%s" % [_index, elm.name]
		_index += 1
	return args


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("arg"):
		var index = property.get_slice("_", 1).to_int()
		_args[index] = value
		_args.insert(index, value)
		return true
	
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("arg"):
		var index = property.get_slice("_", 1).to_int()
		return _args[index] 
	
	return
