@tool
class_name ItemActionEntity
extends MyResource

enum Types{
	CHANGE_PROPERTY = 1,
	NEED_ITEMS = 2,
	REWARD_ITEMS = 4,
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

var need_items: Array[String] = []
var reward_items: Array[String] = []


func _init() -> void:
	super("ITEM_ACTION")


func get_values() -> Dictionary:
	var _result := {}
	if _is_type(type, Types.CHANGE_PROPERTY):
		_result[&"properties"] = _properties
	if _is_type(type, Types.NEED_ITEMS):
		_result[&"need_items"] = need_items
	if _is_type(type, Types.REWARD_ITEMS):
		_result[&"reward_items"] = reward_items
	return _result


func _is_type(value: int, type: Types) -> bool:
	return fmod(value, type * 2) >= type


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if _is_type(type, Types.CHANGE_PROPERTY):
		properties.append(PropertyGenerater.take_dictionary("_properties"))
	if _is_type(type, Types.NEED_ITEMS):
		properties.append(PropertyGenerater.take_simple_array("need_items", "String"))
	if _is_type(type, Types.REWARD_ITEMS):
		properties.append(PropertyGenerater.take_simple_array("reward_items", "String"))
	return properties
