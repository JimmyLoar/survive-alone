@tool
class_name ActionSpecialResource
extends ActionResource

enum {CONDISION, ACTION, CONSTANT}

var _all_specials: Dictionary = {
	"eat": [
		["property_less_than_max"],
		["property_add_value", "inventories_remove_item", "time_use"],
		{
			"property_name": "hunger",
			"amount": 1,
			"for_real_time": 3.0,
			"with_progress_screen": false,
		},
	],
	"drink": [
		[],
		[],
		{},
	],
	"none": [
		[],
		[],
		{},
	],
}

var _special: String:
	set(value):
		_special = value
		notify_property_list_changed()

var _special_args: Dictionary = {}


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append(_property_specials())
	properties.append_array(_property_special_args())
	return properties


func _property_specials():
	var _enum = ','.join(_all_specials.keys())
	var propperty := PropertyGenerater.take_string("_special")
	return PropertyGenerater.convert_to_enum(propperty, _enum)


var methods: Array
func _property_special_args():
	if not methods:
		methods = _action_methods.get_script().get_script_method_list()
	var args: Array = _get_args(_all_specials[_special][CONDISION])
	args.append_array(_get_args(_all_specials[_special][ACTION]))
	args = args.map(_property_modification)
	return args


func _get_args(array: Array) -> Array:
	var args : Array = []
	for _name in array:
		var method_id = methods.find_custom(func(elm): return elm.name == _name)
		var _currect = methods[method_id].args.filter(
			func(elm):
				var constants = _all_specials[_special][CONSTANT] as Dictionary
				return not (constants.has(elm.name) or args.any(func(ready_elm): return elm.name == ready_elm.name))
		)
		args.append_array(_currect)
	return args


func _property_methods() -> Dictionary:
	return {"name": "_method_name", "type": TYPE_NIL, "usage": PROPERTY_USAGE_NO_EDITOR}


func _property_args() -> Array:
	return []















































	
