@tool
class_name ItemData
extends Resource

@export_placeholder("Item N") var name: String
@export_multiline var discription: String = ""
@export var texture: Texture = preload("res://icon.svg")
@export var rare := Rare.NORMAL
@export_range(-1, 65536) var durability := -1
@export var is_pickable := true 

#"health', "hunger", "thirst", "fatigue", "radiation", "psych",



enum Rare{
	GARBAGE, # Мусор или бесполезный хлам
	NORMAL,  # Обычные предметы - ресурсы
	UNIQUE,  # 
	RARE,    #   
	EPIC,    #
	LEGAND,  #
	MYTH,    #
	RARITY,  #
}

const RARE_COLOR = {
	Rare.GARBAGE:Color.WEB_GRAY,
	Rare.NORMAL: Color.WHITE,
	Rare.UNIQUE: Color.LIME_GREEN, 
	Rare.RARE:   Color(0.2695, 0.7771, 0.9844, 1),
	Rare.EPIC:   Color.MEDIUM_PURPLE,
	Rare.LEGAND: Color(0.9725, 1, 0.5098, 1),
	Rare.MYTH:   Color.RED,
	Rare.RARITY: Color.DEEP_PINK,
}


func get_color():
	return RARE_COLOR[rare]

@export_range(0, 6, 1) var action_count := 0:
	set(value):
		action_count = value
		actions.resize(action_count)
		_types.fill(0)
		_types.resize(action_count)
		_properties.resize(action_count)
		_properties.fill(1)
		notify_property_list_changed()

@export_storage var _types: Array[int]:
	set(value):
		_types = value
		notify_property_list_changed()

@export_storage var _properties: Array[int]:
	set(value):
		_properties = value
		notify_property_list_changed()

var actions: Array[Dictionary] = []


enum ActionTypes{
	CHANGE_PROPERTY = 1,
	CHANGE_DURABILITY = 2,
	REQUIRE_ITEMS = 4,
	RECEIVE_ITEMS = 8,
	CAN_STACABLE = 16,
	USE_TIMER = 32,
}

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var _action_type_string := ", ".join(PackedStringArray(ActionTypes.keys())).capitalize()
	
	for i in range(action_count):
		var _name = "action_%d" % i
		properties.append({
			"name": "%s/name" % _name,
			"type": TYPE_STRING,
			})
		
		properties.append({
			"name": "%s/reduced_self" % _name,
			"type": TYPE_BOOL,
			})
		
		properties.append({
			"name": "%s/type" % _name,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_FLAGS,
			"hint_string": _action_type_string,
			})
		
		if has_bit(_types[i], ActionTypes.CHANGE_PROPERTY):
			properties.append_array(_add_property(i))
		
	return properties


func _add_property(i: int) -> Array[Dictionary]:
	var _name = "action_%d" % i
	var properties: Array[Dictionary] = []
	properties.append({
		"name": "%s/propery_size" % _name,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,4,1,or_greater",
		})
	
	for ii in _properties[i]:
		properties.append({
			"name": "%s/property_%s_name" % [_name, ii],
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "exhaustion,hunger,thirst,fatigue,radiation,psych",
			})
		properties.append({
			"name": "%s/property_%s_value" % [_name, ii],
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "-2.1474836488e+06-,2.1474836488e+06,1" 
			})
	return properties


func _get(property):
	if property.begins_with("action_"):
		var index = property.get_slice("/", 0).to_int()
		var key: String = property.get_slice("/", 1)
		if key == "type":
			return _types[index]
		if key == "propery_size":
			return _properties[index]
		return actions[index][key]


func _set(property, value):
	if property.begins_with("action_"):
		var index = property.get_slice("/", 0).to_int()
		var key = property.get_slice("/", 1)
		if key == "type":
			_types[index] = value
		
		elif key == "propery_size":
			_properties[index] = value
		
		else:
			actions[index][key] = value
		return true
	return false


func action_has_type(index: int, type:ActionTypes):
	return has_bit(_types[index], type)


func get_action_types(action_index: int) -> Array[bool]:
	var types: Array[bool] = []
	for i in ActionTypes.size():
		var _result = has_bit(_types[action_index], ActionTypes.values()[i])
		types.append(_result)
	return types


static func has_bit(value: int, bit: int) -> bool:
	return fmod(value, bit * 2) >= bit
