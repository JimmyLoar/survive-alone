@tool
class_name EventResource
extends NamedResource

var ACTION_DICTIONARY = {
	"text": 'exit',
	"is_said": false,
	"icon": preload("res://icon.svg"),
	"conditions": [],
	"next_stage": -1,
	"action_resource": null,
}

var STAGE = {
	"name": "",
	"texture": null,
	"text": "",
	"actions": Array([ACTION_DICTIONARY], TYPE_DICTIONARY, "", null),
}


@export_range(1, 16, 1, "or_greater") var _stages: int = 1:
	set(value):
		_stages = value
		_action_count.resize(value)
		stages.resize(value)
		notify_property_list_changed()


@export_storage var _action_count: Array[int] = [1]:
	set(value):
		_action_count.clear()
		for x in value:
			var element = clamp(x, 1, 6)
			_action_count.append(element)

var stages: Array[Dictionary] = [STAGE.duplicate()]

func _init() -> void:
	super("EVENT")
	var stage = STAGE.duplicate()
	stage.name = "main"
	stages.append(stage)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for i in _stages:
		properties.append_array(_get_stage_properies(i))
		properties.append_array(_get_actions_properties(i))
	return properties


func _get_stage_properies(stage_index: int) -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var _name := "stage_%s" % stage_index
	properties.append(PropertyGenerater.take_string(_name + "/name"))
	properties.append(PropertyGenerater.take_resource(_name + "/texture", "Texture2D"))
	properties.append(PropertyGenerater.take_string(_name + "/text"))
	properties.append(PropertyGenerater.convent_to_range(
		PropertyGenerater.take_int(_name + "/actions_count"), 
		1, 6))
	return properties


func _get_actions_properties(stage_index: int) -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for i in _action_count[stage_index]:
		i += 1
		properties.append(PropertyGenerater.take_string("stage_%s/action_%s/text" % [stage_index, i]))
		properties.append(PropertyGenerater.take_bool("stage_%s/action_%s/is_said" % [stage_index, i]))
		properties.append(PropertyGenerater.take_resource("stage_%s/action_%s/icon" % [stage_index, i], "Texture2D"))
		properties.append(PropertyGenerater.convent_to_range(
			PropertyGenerater.take_int("stage_%s/action_%s/next_stage" % [stage_index, i]),
			-1, _stages - 1, 1))
		properties.append(PropertyGenerater.take_resource("stage_%s/action_%s/action_resource" % [stage_index, i], "EventActionResource"))
		properties.append(PropertyGenerater.take_simple_array("stage_%s/action_%s/conditions" % [stage_index, i], "int"))
	return properties


func _get_new_stage_dir():
	return STAGE.duplicate(true)


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("stage"):
		var index = property.get_slice("/", 0).to_int()
		var key_0 = property.get_slice("/", 1)
		var key_1 = property.get_slice("/", 2)
		if key_0.begins_with("action_"):
			var action_index = key_0.to_int() - 1
			print(stages)
			var actions = stages[index]["actions"]
			if not actions[action_index]:
				actions[action_index] = ACTION_DICTIONARY.duplicate()
			#elif stages[index]["actions"][action_index].is_read_only():
				#stages[index]["actions"][action_index] = stages[index]["actions"][action_index].duplicate()
			actions[action_index][key_1] = value
		elif key_0 == "actions_count":
			if not stages[index].has("actions"):
				stages[index]["actions"] = []
			stages[index]["actions"].resize(value)
			_action_count[index] = value
			notify_property_list_changed()
		else:
			stages[index][key_0] = value
		return true
	return false


func _get(property: StringName):
	if property.begins_with("stage"):
		var index = property.get_slice("/", 0).to_int() as int
		var key_0 = property.get_slice("/", 1) as String
		var key_1 = property.get_slice("/", 2) as String
		if stages[index].has(key_0):
			return stages[index][key_0]
	
		elif key_0.begins_with("action_"):
			var action_index = key_0.to_int() - 1
			var actions = stages[index]["actions"]
			stages[index]["actions"].resize(_action_count[index])
			var action = actions[action_index] 
			if action.has(key_1):
				return action[key_1]
		
		elif  key_0 == "actions_count":
			return _action_count[index]
	
	return _property_get_revert(property)


func _property_can_revert(property: StringName) -> bool:
	if property.begins_with("stage"):
		return true
	return false


func _property_get_revert(property: StringName) -> Variant:
	if property.begins_with("stage"):
		var key = property.get_slice("/", 1)
		if key == "actions_count":
			var index: int = property.get_slice("/", 0).to_int()
			return _action_count[index]
		elif key.begins_with("action_"):
			var key_1 = property.get_slice("/", 2)
			return ACTION_DICTIONARY.duplicate()[key_1]
		elif key == "actions":
			return [ACTION_DICTIONARY.duplicate()]
		return _get_new_stage_dir()[key] 
	return null
