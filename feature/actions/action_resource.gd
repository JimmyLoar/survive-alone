@tool
class_name ActionResource
extends Resource

var _action_methods := ActionMethods.get_instantiate()


var _method_name: String = '':
	set(value):
		_method_name = value
		_args.resize(_action_methods.get_method_argument_count(_method_name))
		notify_property_list_changed()


var _args : Array = []:
	get = get_arguments


func execute() -> Variant:
	return _action_methods.callv(_method_name, _args)


func get_argument_names() -> Array:
	return _get_args().map(func(elm): return elm.name)

func get_arguments():
	return _args


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
	var _index = 0
	var args = []
	for elm in _get_args():
		var _arg = _property_modification(elm)
		_arg.name = "arg_%d: %s" % [_index, elm.name]
		_index += 1
		args.append(_arg)
	
	_args.resize(args.size())
	return args


func _get_args() -> Array[Dictionary]:
	var methods = _action_methods.get_script().get_script_method_list() as Array
	var method_id = methods.find_custom(func(elm): return elm.name == _method_name)
	return methods[method_id].args


static func _property_modification(prop: Dictionary):
	prop.usage = PROPERTY_USAGE_DEFAULT
	if   prop.name == "property_name":
		return _modification_character_property(prop)
	elif prop.name == "item_name":
		return _modification_items(prop)
	elif prop.name == "game_time" or prop.name == "for_real_time":
		return _modification_time(prop)
	elif prop.name == "used_array":
		return _modification_int_array(prop)
	elif prop.name == "_inventory":
		return _modification_inventory(prop)
	elif prop.name == "amount":
		return _modification_amount(prop)
	elif prop.name == "eventpack_name":
		return _modification_eventpack(prop)
	elif prop.name == "event_name":
		return _modification_event(prop)
	return prop


static func _modification_character_property(prop: Dictionary):
	var _enum = "exhaustion,fatigue,hunger,psych,radiation,thirst"
	return PropertyGenerater.convert_to_enum(prop, _enum)


static func _modification_inventory(prop: Dictionary):
	var _enum = "InventoryCharacter,InventoryLocation"
	return PropertyGenerater.convert_to_enum(prop, _enum)


static func _modification_int_array(prop: Dictionary):
	var new_prop = PropertyGenerater.take_array(prop.name, TYPE_INT, PROPERTY_HINT_RANGE, "1,100,1,or_greater")
	prop.merge(new_prop, true)
	return prop


static func _modification_time(prop: Dictionary):
	prop.type = TYPE_FLOAT
	return PropertyGenerater.convent_to_range(prop, 0.1, 60, 0.1, "or_greater")


static func _modification_items(prop: Dictionary):
	var _item_names = ResourceCollector.keys(ResourceCollector.Collection.ITEMS)
	return PropertyGenerater.convert_to_enum(prop, ",".join(_item_names))


static func _modification_amount(prop: Dictionary):
	return PropertyGenerater.convent_to_range(prop, 0, 100, 1, "or_greater")


static func _modification_event(prop: Dictionary):
	var _item_names = ResourceCollector.keys(ResourceCollector.Collection.EVENTS)
	return PropertyGenerater.convert_to_enum(prop, ",".join(_item_names))


static func _modification_eventpack(prop: Dictionary):
	var _item_names = ResourceCollector.keys(ResourceCollector.Collection.EVENTS_LIST)
	return PropertyGenerater.convert_to_enum(prop, ",".join(_item_names))


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("arg"):
		var index = property.get_slice(": ", 0).to_int()
		_args.set(index, value)
		return true
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("arg"):
		var index = property.get_slice(": ", 0).to_int()
		return _args[index] 
	return
