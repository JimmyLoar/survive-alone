extends Node

const MULTIPER = 1000

var logger :=  GodotLogger.with("Player Properties")

var _properties_data: Dictionary = {
	preload("res://database/property/exhaustion.tres").name_key: preload("res://database/property/exhaustion.tres"),
	preload("res://database/property/hunger.tres").name_key: preload("res://database/property/hunger.tres"),
	preload("res://database/property/thirst.tres").name_key: preload("res://database/property/thirst.tres"),
	preload("res://database/property/fatigue.tres").name_key: preload("res://database/property/fatigue.tres"),
	preload("res://database/property/radiation.tres").name_key: preload("res://database/property/radiation.tres"),
	preload("res://database/property/psych.tres").name_key: preload("res://database/property/psych.tres"),
}

var _properties_value: Dictionary = {
	
}


func _init() -> void:
	_init_values()


func _init_values():
	for key in _properties_data.keys():
		_set_value(key, _properties_data[key].default_value)
		_set_value(key + "_delta", _properties_data[key].default_delta_value)
	pass


func update(delta_time: int = 1):
	for prop in _properties_data.keys():
		var value: int = _get_value(prop) + _get_value("%s_delta" % prop) * delta_time 
		_set_value(prop, value)
	return


func _set_value(property_name: String, value: int):
	_properties_value[property_name] = min(value, 
		get_property(property_name).default_max_value * MULTIPER
		)


func set_value(property_name: String, value: float):
	_set_value(property_name, int(value * MULTIPER))


func _get_value(property_name: String, default: Variant = 0) -> int:
	if _properties_value.has(property_name):
		return _properties_value[property_name]
	return default


func get_value(property_name: String, default: Variant = 0) -> float:
	return _get_value(property_name, default) / MULTIPER


func get_property(property_name: String) -> GameProperty:
	if not _properties_data.has(property_name):
		return preload("res://database/property/none_property.tres")
	return _properties_data[property_name]


func get_value_properties_list() -> Array[String]:
	return _properties_value.keys()


func get_data_properties_list() -> Array[String]:
	return _properties_data.keys()
