@tool
class_name ActionResource
extends Resource

var _action_methods := ActionMethods.get_instantiate()


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
	properties.append(_property_methods())
	properties.append_array(_property_args())
	return properties


func _property_methods() -> Dictionary:
	var property = PropertyGenerater.take_string("_method_name")
	var _methods = _action_methods.get_script().get_script_method_list().filter(
		func(elm):
			return not (elm.name.begins_with("_") 
				or elm.name.begins_with("@")
				or elm.name == "get_instantiate"
			)
	)
	_methods = _methods.map(func(elm): return elm.name)
	return PropertyGenerater.convert_to_enum(property, ",".join(_methods))


func _property_args() -> Array:
	var methods = _action_methods.get_script().get_script_method_list() as Array
	var method_id = methods.find_custom(func(elm): return elm.name == _method_name)
	var args = methods[method_id].args as Array
	var _index = 0
	for elm in args:
		elm.name = "arg_%d_%s" % [_index, elm.name]
		_index += 1
	return args.map(_property_modification) 


func _property_modification(prop: Dictionary):
	prop.usage = PROPERTY_USAGE_DEFAULT
	if prop.name.contains("property"):
		return _modification_character_property(prop)
	elif prop.name.contains("item"):
		return _modification_items(prop)
	elif prop.name.contains("time"):
		return _modification_time(prop)
	elif prop.name.contains("used"):
		return _modification_int_array(prop)
	elif prop.name.contains("inventory"):
		return _modification_inventory(prop)
	elif prop.name.contains("amount"):
		return _modification_amount(prop)
	elif prop.name.contains("eventpack"):
		return _modification_eventpack(prop)
	elif prop.name.contains("event"):
		return _modification_event(prop)
	return prop


func _modification_character_property(prop: Dictionary):
	var _enum = "exhaustion,fatigue,hunger,psych,radiation,thirst"
	return PropertyGenerater.convert_to_enum(prop, _enum)


func _modification_inventory(prop: Dictionary):
	var _enum = "InventoryCharacterState,InventoryLocationState"
	return PropertyGenerater.convert_to_enum(prop, _enum)


func _modification_int_array(prop: Dictionary):
	var new_prop = PropertyGenerater.take_array(prop.name, TYPE_INT, PROPERTY_HINT_RANGE, "1,100,1,or_greater")
	prop.merge(new_prop, true)
	return prop


func _modification_time(prop: Dictionary):
	return PropertyGenerater.convent_to_range(prop, 0.1, 1440, 0.1, "or_greater")


func _modification_items(prop: Dictionary):
	var _item_names = preload("res://resources/database.gddb").get_data_string_ids("items")
	return PropertyGenerater.convert_to_enum(prop, ",".join(_item_names))


func _modification_amount(prop: Dictionary):
	return PropertyGenerater.convent_to_range(prop, 0, 100, 1, "or_greater")


func _modification_event(prop: Dictionary):
	var _item_names = preload("res://resources/database.gddb").get_data_string_ids("event")
	return PropertyGenerater.convert_to_enum(prop, ",".join(_item_names))


func _modification_eventpack(prop: Dictionary):
	var _item_names = preload("res://resources/database.gddb").get_data_string_ids("event_list")
	return PropertyGenerater.convert_to_enum(prop, ",".join(_item_names))


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("arg"):
		var index = property.get_slice("_", 1).to_int()
		_args[index] = value
		_args.set(index, value)
		return true
	
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("arg"):
		var index = property.get_slice("_", 1).to_int()
		return _args[index] 
	
	return
