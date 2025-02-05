@tool
class_name ActionResource
extends NamedResource

const ACTION_NONE 				= "NONE"
const ACTION_CHANGE_PROPERTY 	= "CHANGE_PROPERTIES"
const ACTION_NEED_ITEMS 		= "NEED_ITEMS"
const ACTION_REWARD_ITEMS 		= "REWARD_ITEMS"

var Actions = {
	NONE = 0,
	CHANGE_PROPERTIES 	= Utils.NUMB_POWERS_2[0],
	NEED_ITEMS 			= Utils.NUMB_POWERS_2[1],
	REWARD_ITEMS 		= Utils.NUMB_POWERS_2[2],
}


var type := 1:
	set(value):
		type = value
		notify_property_list_changed()


var _properties: Dictionary = {
	"exhaustion"	: 0,
	"hunger"		: 0, 
	"thirst"		: 0, 
	"fatigue"		: 0, 
	"radiation"		: 0, 
	"psych"			: 0,
} 


var need_items: Dictionary = {}
var reward_items: Dictionary = {}
var used_item_keys := []:
	set(value):
		used_item_keys = value
		need_items.merge(Utils.create_dictionary_with_keys(value, 0))
		need_items = Utils.dictionary_erase_keys_without_list(need_items, value)
		reward_items.merge(Utils.create_dictionary_with_keys(value, 0))
		reward_items = Utils.dictionary_erase_keys_without_list(reward_items, value)
		notify_property_list_changed()

var _items_names: PackedStringArray = []


func _init() -> void:
	super("ACTION")
	if Engine.is_editor_hint():
		var database := preload("res://resources/database.gddb")
		_items_names = PackedStringArray(database.get_data_string_ids(&"items"))
		notify_property_list_changed()


func get_values() -> Dictionary:
	var _result := {}
	if _is_type(type, Actions.CHANGE_PROPERTIES):
		_result[&"properties"] = _properties
	if _is_type(type, Actions.NEED_ITEMS):
		_result[&"need_items"] = need_items
	if _is_type(type, Actions.REWARD_ITEMS):
		_result[&"reward_items"] = reward_items
	return _result


func has_type_key(_type: String) -> bool:
	return Actions.has(_type) 


func has_type(_type: String) -> bool:
	if has_type_key(_type):
		return _is_type(type, Actions[_type])
	return false


func _is_type(value: int, type: int) -> bool:
	return fmod(value, type * 2) >= type


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var flags: PackedStringArray = []
	for i in range(Actions.size()):
		var key: String = Actions.keys()[i]
		if key == "NONE": 
			continue
		flags.append("%s:%d" % [key, Actions[key]])
	properties.append(PropertyGenerater.take_flags("type", flags))
	
	if _is_type(type, Actions.CHANGE_PROPERTIES):
		properties.append(PropertyGenerater.take_dictionary("_properties"))
	
	if _is_type(type, Actions.NEED_ITEMS):
		properties.append(PropertyGenerater.take_dictionary("need_items"))
	
	if _is_type(type, Actions.REWARD_ITEMS):
		properties.append(PropertyGenerater.take_dictionary("reward_items"))
	
	if _is_type(type, Actions.REWARD_ITEMS) or _is_type(type, Actions.NEED_ITEMS):
		var prop := PropertyGenerater.take_array("used_item_keys", TYPE_STRING, PROPERTY_HINT_ENUM_SUGGESTION, ','.join(_items_names))
		properties.append(prop)
	
	return properties
