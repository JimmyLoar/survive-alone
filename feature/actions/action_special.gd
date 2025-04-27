@tool
class_name ActionSpecial
extends ActionAggregate

enum {CONDISION, ACTION, CONSTANT}

const _all_specials: Dictionary = {
	"eat": [
		["property_less_than_max"],
		["property_add_value", "inventories_remove_item", "time_use"],
		{
			"property_name": "hunger",
			"amount": 1,
			"for_real_time": 1.0,
			"with_progress_screen": false,
		},
	],
	"drink": [
		["property_less_than_max"],
		["property_add_value", "inventories_remove_item", "time_use"],
		{
			"property_name": "thirst",
			"amount": 1,
			"for_real_time": 1.0,
			"with_progress_screen": false,
		},
	],
	"none": [
		[],
		[],
		{
			
		},
	],
}

var addational_condition: Array[ActionResource] = []
var addational_actions: Array[ActionResource] = []

var _action_methods := ActionMethods.get_instantiate()

var _special: String = _all_specials.keys().front():
	set(value):
		_special = value
		notify_property_list_changed()

var _special_args: Dictionary = {}
@export_storage var _cache_updated_args = []


func is_meet_conditions() -> bool:
	var result := true
	for _name in _all_specials[_special][CONDISION]:
		result = result && _action_methods.callv(_name, get_args_to_methods(_name))
	
	for action in addational_condition:
		result = result && action.execute()
	
	#_logger.debug("'%s' is meet conditions?" % [get_action_name()], result)
	return result


func execute() -> Array:
	if not is_meet_conditions():
		return []
	
	var result: Array = []
	for _name in _all_specials[_special][ACTION]:
		result.append(_action_methods.callv(_name, get_args_to_methods(_name)))
	
	for action in addational_actions:
		result.append(action.execute())
	
	_logger.debug("'%s' executed" % [get_action_name()], result)
	return result


func get_args_to_methods(method_name: String) -> Array:
	if not methods or methods.is_empty():
		methods = _action_methods.get_script().get_script_method_list()
	
	var method_id = methods.find_custom(func(elm): return elm.name == method_name)
	var _args_name = methods[method_id].args.map(func(elm): return elm.name)
	var constants = _all_specials[_special][CONSTANT]
	
	var args := Array()
	for _name in _args_name:
		if constants.has(_name):
			args.append(constants[_name])
			continue
		args.append(_special_args[_name])
	return args


func has_method_begin_with(string: String):
	var array = []
	array.append_array(_cache_updated_args)
	array.append_array(_all_specials[_special][CONSTANT].keys())
	printerr(array)
	return array.any(func(elm: String): return elm.begins_with(string))


func get_action_name():
	return _special


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	_cache_updated_args = []
	properties.append(_property_specials())
	properties.append_array(_property_special_args())
	properties.append(PropertyGenerater.take_array("addational_actions", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "ActionResource"))
	return properties


func _property_specials():
	var _enum = ','.join(_all_specials.keys())
	var propperty := PropertyGenerater.take_string("_special")
	return PropertyGenerater.convert_to_enum(propperty, _enum)


static var methods: Array
func _property_special_args():
	if not _cache_updated_args:
		_cache_updated_args = []
	
	if not methods:
		methods = _action_methods.get_script().get_script_method_list()
	
	var _used_methods = []
	_used_methods.assign(_all_specials[_special][CONDISION])
	_used_methods.append_array(_all_specials[_special][ACTION])
	
	var args = []
	for _method_name in _used_methods:
		var method_id = methods.find_custom(func(elm): return elm.name == _method_name)
		args.append_array(_get_method_args(method_id))
	return args


func _get_method_args(method_id: int) -> Array:
	var _currect = []
	for arg: Dictionary in methods[method_id].args:
		if (_cache_updated_args.has(arg.name)
			or _all_specials[_special][CONSTANT].has(arg.name)):
			continue
		
		_cache_updated_args.append(arg.name)
		var _arg = ActionResource._property_modification(arg.duplicate())
		_arg.name = "override: %s" % [arg.name]
		_currect.append(_arg)
	return _currect


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("override"):
		var key = property.get_slice(": ", 1) as StringName
		_special_args.set(key, value)
		#print_debug("set %s == %s\n%s\n" % [property, value, _special_args])
		return true
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("override"):
		var key = property.get_slice(": ", 1)
		return _special_args[key] 
	return











































	
