extends Node

var logger :=  GodotLogger.with("Player Properties")

var _properties_data: Dictionary = {
	"none": {
		"name": "None",
		"texture": null,
		"default_value": -1,
		"default_max_value": 100,
	},
	
	"health": {
		"extend": "none",
		"name": "Health",
	},
	
	"hunger": {
		"extend": "none",
	},
	
	"thirst": {
		"extend": "none",
	},
	
	"fatigue": {
		"extend": "none",
	},
	
	"radiation": {
		"extend": "none",
		"default_value": 0,
		"default_max_value": 128,
	},
	
	"psych": {
		"extend": "none",
		"default_max_value": 128,
	},
}

var _properties_value: Dictionary = {
	
}


func _init() -> void:
	_init_values()


func _init_values():
	for prop in _properties_data.keys():
		var property := _properties_data[prop] as Dictionary
		if property.has("extend"):
			var extend_key = property.extend
			property.merge(_properties_data[extend_key])
			property.erase("extend")
		
		var value = get_property_data_or_null(prop, "default_value")
		if value == -1:
			value = get_property_data_or_null(prop, "default_max_value")
		set_value(prop, value)


func set_value(property_name: String, value):
	_properties_value[property_name] = value


func get_value(property_name: String, default: Variant = 0):
	if _properties_value.has(property_name):
		return _properties_value[property_name]
	return default


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
	return property[data_key]


func get_value_properties_list() -> Array[String]:
	return _properties_value.keys()


func get_data_properties_list() -> Array[String]:
	return _properties_data.keys()
