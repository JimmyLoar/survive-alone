@tool
class_name ActionAggregate
extends Resource


enum {CONDISION, ACTION, CONSTANT}

const _all_specials: Dictionary = {
	# key: [[condition_names], [action_names], {constant_key: constant_value}],
	"none": [[], [], {}],
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
}

var addational_condition: Array[ActionResource] = []
var addational_actions: Array[ActionResource] = []
var special: String = "":
	set(value):
		special = _all_specials.keys().front() if not value or value.is_empty() else value
		emit_changed()
		notify_property_list_changed()

var _cache_updated_args: Array[String] = []
var _action_methods := ActionMethods.get_instantiate()
var _special_args: Dictionary = {}

#var _logger := Log.get_global_logger().with("ActionAggregate")


func is_meet_conditions() -> bool:
	var result := true
	for _name in _all_specials[special][CONDISION]:
		var _args = get_arguments_to_method(_name)
		result = result && _action_methods.callv(_name, _args)
	
	for action in addational_condition:
		result = result && action.execute()
	
	#_logger.debug("'%s' is meet conditions?" % [get_action_name()], result)
	return result


func execute() -> Array:
	if not is_meet_conditions():
		return []
	
	var result: Array = []
	for _name in _all_specials[special][ACTION]:
		result.append(_action_methods.callv(_name, get_arguments_to_method(_name)))
	
	for action in addational_actions:
		result.append(action.execute())
	
	#_logger.debug("'%s' executed" % [get_action_name()], result)
	return result


func get_action_name():
	return special


func get_arguments_to_method(method_name) -> Array:
	var constants = _all_specials[special][CONSTANT]
	var args := Array()
	for _name in get_argument_names(method_name):
		if constants.has(_name):
			args.append(constants[_name])
			continue
		args.append(_special_args[_name])
	return args


func get_methods_names() -> Array:
	return get_special_methods_names()


func get_argument_names(method_name) -> Array:
	var args = Array()
	for arg in _get_method_args(method_name):
		if args.has(arg.name):
			continue
		args.append(arg.name)
	return args


func get_override_argument_names() -> Array:
	var args = _property_special_args()
	args = args.map(func(elm): return elm.name.trim_prefix("override: "))
	return args


func get_special_methods_names() -> Array[String]:
	var _used_methods: Array[String] = []
	_used_methods.assign(_all_specials[special][CONDISION])
	_used_methods.append_array(_all_specials[special][ACTION])
	return _used_methods


func _get_property_list() -> Array[Dictionary]:
	_cache_updated_args = [] 
	var properties: Array[Dictionary] = []
	properties.append(_property_specials())
	properties.append_array(_property_special_args())
	properties.append(PropertyGenerater.take_array("addational_condition", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "ActionResource"))
	properties.append(PropertyGenerater.take_array("addational_actions", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "ActionResource"))
	return properties


func _property_specials():
	var _enum = ','.join(_all_specials.keys())
	var propperty := PropertyGenerater.take_string("special")
	return PropertyGenerater.convert_to_enum(propperty, _enum)


static var methods: Array
func _property_special_args() -> Array:
	var args: Array = []
	for method_name in get_special_methods_names():
		args.append_array(_extrude_args(_get_method_args(method_name)))
	return args


func _get_method_args(_method_name: String) -> Array[Dictionary]:
	if not methods or methods.is_empty():
		methods = _action_methods.get_script().get_script_method_list()
	var method_id = methods.find_custom(func(elm): return elm.name == _method_name)
	return methods[method_id].args


func _extrude_args(args: Array[Dictionary]) -> Array[Dictionary]:
	var _currect: Array[Dictionary] = []
	for arg: Dictionary in args:
		if (_cache_updated_args.has(arg.name)
			or _all_specials[special][CONSTANT].has(arg.name)):
			continue
		
		_cache_updated_args.append(arg.name)
		if not _special_args.has(arg.name):
			_special_args[arg.name] = null
		
		var _arg = ActionResource._property_modification(arg.duplicate())
		_arg.name = "override: %s" % [arg.name]
		_currect.append(_arg)
	return _currect


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("override"):
		var key = property.get_slice(": ", 1) as StringName
		_special_args.set(key, value)
		emit_changed()
		return true
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("override"):
		var key = property.get_slice(": ", 1)
		return _special_args[key] 
	return



	
