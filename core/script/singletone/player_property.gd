class_name PlayerPropertiesController

const MULTIPER = 1000
const COLECTION_NAME = &"properties"

var logger :=  GodotLogger.with("Player Properties")

var _properties_value: Dictionary = {
	
}
var _database: Database


func set_database(database: Database):
	_database = database
	_init_values()


func _init_values():
	for data: GameProperty in get_properties_data().values():
		var value = data.default_value 
		if value == -1: 
			value = data.default_max_value
		set_value(data.name_key, value)
		set_value(data.name_key + "_delta", data.default_delta_value)


func update(delta_time: int = 1):
	for prop: GameProperty in get_properties_data().values():
		var key = prop.name_key
		var value: int = _get_value(key) + _get_value("%s_delta" % key) * delta_time 
		_set_value(key, value)
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


func get_property(_name: StringName) -> GameProperty:
	if _name.ends_with("_delta"):
		_name = _name.trim_suffix("_delta")
	return _database.fetch_data(COLECTION_NAME, _name)


func get_value_properties_list() -> Array[String]:
	return _properties_value.keys()


func get_properties_data() -> Dictionary:
	return _database.fetch_collection_data(COLECTION_NAME)
	
