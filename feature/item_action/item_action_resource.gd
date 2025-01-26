@tool
class_name ItemActionResource
extends MyResource

enum Types{
	CHANGE_PROPERTY = 1,
	NEED_ITEMS = 2,
	REWARD_ITEMS = 4,
	CHANGE_DURABILITY = 8,
	REDUCED_BY_USE = 16,
}

@export_flags(
	"Change Property:%d" % Types.CHANGE_PROPERTY,
	"Need Items:%d" % Types.NEED_ITEMS,
	"Reward Items:%d" % Types.REWARD_ITEMS,
	) var type := 0:
		set(value):
			type = value
			notify_property_list_changed()

@export var use_stack := false

var _properties: Dictionary = {
	"exhaustion": 0,
	"hunger": 0, 
	"thirst": 0, 
	"fatigue": 0, 
	"radiation": 0, 
	"psych": 0,
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
	super("ITEM_ACTION")
	if Engine.is_editor_hint():
		var database := preload("res://resources/database.gddb")
		_items_names = PackedStringArray(database.get_data_string_ids(&"items"))
		notify_property_list_changed()


func get_values() -> Dictionary:
	var _result := {}
	if _is_type(type, Types.CHANGE_PROPERTY):
		_result[&"properties"] = _properties
	if _is_type(type, Types.NEED_ITEMS):
		_result[&"need_items"] = need_items
	if _is_type(type, Types.REWARD_ITEMS):
		_result[&"reward_items"] = reward_items
	return _result


func has_type(_type: Types) -> bool:
	return _is_type(type, _type)


func _is_type(value: int, type: Types) -> bool:
	return fmod(value, type * 2) >= type


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if _is_type(type, Types.CHANGE_PROPERTY):
		properties.append(PropertyGenerater.take_dictionary("_properties"))
	
	if _is_type(type, Types.NEED_ITEMS):
		properties.append(PropertyGenerater.take_dictionary("need_items"))
	
	if _is_type(type, Types.REWARD_ITEMS):
		properties.append(PropertyGenerater.take_dictionary("reward_items"))
	
	if _is_type(type, Types.REWARD_ITEMS) or _is_type(type, Types.NEED_ITEMS):
		var prop := PropertyGenerater.take_array("used_item_keys", TYPE_STRING, PROPERTY_HINT_ENUM_SUGGESTION, ','.join(_items_names))
		properties.append(prop)
	
	return properties
