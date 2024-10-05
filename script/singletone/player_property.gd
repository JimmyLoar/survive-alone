extends Node

const MULTIPER = 1000

var logger :=  GodotLogger.with("Player Properties")

var _properties_data: Dictionary = {
	"none": {
		"name": "None",
		"texture": preload("res://icon.svg"),
		"default_value": -1,
		"default_max_value": 100,
		"default_delta_value": 0.0,
		"modulate": Color.WHITE,
	},
	
	"health": {
		"extend": "none",
		"name": "Health",
		"modulate": Color.WEB_GREEN,
	},
	
	"hunger": {
		"extend": "none",
		"default_delta_value": -0.0132 * 1.4,
		"modulate": Color.ORANGE_RED,
	},
	
	"thirst": {
		"extend": "none",
		"default_delta_value": -0.0388 * 1.4,
		"modulate": Color.SKY_BLUE,
	},
	
	"fatigue": {
		"extend": "none",
		"default_delta_value": -0.004 * 1.4,
		"modulate": Color.YELLOW,
	},
	
	"radiation": {
		"extend": "none",
		"default_value": 0,
		"default_max_value": 128,
		"modulate": Color.DARK_SALMON,
	},
	
	"psych": {
		"extend": "none",
		"default_max_value": 128,
		"modulate": Color.MEDIUM_PURPLE,
	},
}

var _properties_value: Dictionary = {
	
}


func _init() -> void:
	_init_values()


func _init_values():
	for prop in _properties_data.keys():
		if prop == "none": continue
		var property := _properties_data[prop] as Dictionary
		if property.has("extend"):
			var extend_key = property.extend
			property.merge(_properties_data[extend_key])
			property.erase("extend")
		
		var value = get_property_data_or_null(prop, "default_value")
		if value == -1:
			value = get_property_data_or_null(prop, "default_max_value") 
		
		set_value(prop, int(value * MULTIPER))
		_set_value("%s_delta" % prop, int(get_property_data_or_null(prop, "default_delta_value") * MULTIPER))
	logger.info("Initianalize properties value:	%s" % _properties_value)


func update(delta_time: int = 1):
	for prop in _properties_data.keys():
		if prop == "none": continue
		var value: int = _get_value(prop) + _get_value("%s_delta" % prop) * delta_time 
		_set_value(prop, value)
	return


func _set_value(property_name: String, value: int):
	_properties_value[property_name] = min(value, 
		get_property_data_or_null(property_name, "default_max_value") * MULTIPER
		)


func set_value(property_name: String, value: float):
	_set_value(property_name, int(value * MULTIPER))


func _get_value(property_name: String, default: Variant = 0) -> int:
	if _properties_value.has(property_name):
		return _properties_value[property_name]
	return default


func get_value(property_name: String, default: Variant = 0) -> float:
	return _get_value(property_name, default) / MULTIPER


func get_property(property_name: String):
	if not _properties_data.has(property_name):
		return {}
	return _properties_data[property_name]


func get_property_data_or_null(
		property_name: String, data_key: String = "name", 
		defualt_value: Variant = 0) -> Variant:
	
	var property: Dictionary = get_property(property_name)
	if not property.has(data_key):
		logger.debug("Not founded data key '%s' in property '%s'" % [data_key, property_name])
		logger.debug("Returted value '%s'" % defualt_value)
		return defualt_value
	
	#logger.info("founded %s.%s: %s" % [property_name, data_key, property[data_key]])
	return property[data_key]


func get_value_properties_list() -> Array[String]:
	return _properties_value.keys()


func get_data_properties_list() -> Array[String]:
	return _properties_data.keys()
