@tool
class_name AddProppertyAction
extends IAction


@export_range(1, 4) var count_properties := 1:
	set(value):
		count_properties = value
		_properties.resize(value)
		notify_property_list_changed()


var _properties: Array[Dictionary] = [{
	"name": "",
	"value": 0,
}]


func set_dependence(objects: Array):
	if objects[0] as PlayerPropertiesController:
		_dependence = objects[0]
		return
	
	_dependence = null
	GodotLogger.warn("%s | setted dependence array have not [color=green]PlayerPropertiesController[/color]" % [self.get_script().get_global_name()], objects)
	return


func execute():
	var properties: PlayerPropertiesController = _dependence
	for i in count_properties:
		var _name = _properties[i].name
		var value = _properties[i].value + properties.get_value(_name)
		properties.set_value(_name, value)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var property_names = "exhaustion,hunger,thirst,fatigue,radiation,psych"
	for i in count_properties:
		properties.append_array(_add_property(i, property_names))
	
	properties.append({
		"name": "_dependence",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": property_names,
		"usage": PROPERTY_USAGE_DEFAULT,
		})
	return properties


func _add_property(i: int, property_names: String) -> Array[Dictionary]:
	var _name = "property_%d" % i
	var properties: Array[Dictionary] = []
	properties.append({
		"name": "%s/name" % [_name],
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": property_names,
		})
	properties.append({
		"name": "%s/value" % [_name],
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-2.1474836488e+06-,2.1474836488e+06,1" 
		})
	return properties


func _get(property):
	if property.begins_with("property_"):
		var index = property.get_slice("/", 0).to_int()
		var key: String = property.get_slice("/", 1)
		return _properties[index][key]


func _set(property, value):
	if property.begins_with("property_"):
		var index = property.get_slice("/", 0).to_int()
		var key = property.get_slice("/", 1)
		_properties[index][key] = value
		return true
	return false