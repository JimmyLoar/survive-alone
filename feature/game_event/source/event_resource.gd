@tool
class_name EventResource
extends NamedResource


static var ACTION_DICTIONARY = {
	"text": 'exit',
	"is_said": false,
	"icon": preload("res://icon.svg"),
	"conditions": [],
	"next_stage": -1,
	"action_resource": null,
}

static var STAGE = {
	"name": "stage name",
	"text": "exemple text",
	"texture": null,
	"actions": Array([], TYPE_DICTIONARY, "", null),
}

@export_range(0, 6, 1, "or_greater") var _stage_count := 0:
	set(value):
		_stage_count = value
		_stages.resize(value)
		for i in value:
			_stages[i] = STAGE.duplicate()
			_stages[i].actions = [ACTION_DICTIONARY.duplicate(), ACTION_DICTIONARY.duplicate()]
		notify_property_list_changed()
@export var _stages: Array[Dictionary] = []
var _ids: PackedStringArray = []


func _init(_name: String = "", stages_count: int = 1) -> void:
	super("EVENT")
	code_name = _name


#region Stage
func add_stage(_name: String, text: String= "", texture: Texture2D = null) -> int:
	var stage := {
		"name": _name,
		"text": text,
		"texture": texture,
		"actions": Array([], TYPE_DICTIONARY, "", null),
	}
	return set_stage(stage)


func set_stage(stage_data: Dictionary, stage_id: int = -1) -> int:
	stage_data = _validate_stage(stage_data)
	if stage_id == -1:
		stage_id = _stages.size()
		_stages.append(stage_data)
		_ids.append(stage_data.name)
	else:
		_stages[stage_id] = stage_data
		_ids[stage_id] = stage_data.name
	return stage_id


func get_stage(stage_id: int):
	stage_id = clamp(stage_id, 0, _stages.size() - 1)
	return _stages[stage_id]


func found_stage(stage_name: String):
	return _ids.find(stage_name)


func get_full_data() -> Array[Dictionary]:
	return _stages.duplicate()


func _get_new_stage() -> Dictionary:
	return STAGE.duplicate()


func _validate_stage(stage: Dictionary) -> Dictionary:
	if stage.is_empty(): 
		return STAGE.duplicate()
	if not stage.has("name") or typeof(stage.name) != TYPE_STRING:
		stage["name"] = STAGE.name
	if not stage.has("text") or typeof(stage.name) != TYPE_STRING: 
		stage["text"] = STAGE.text
	if not stage.has("texture") or stage.texture is not Texture2D:
		stage["texture"] = STAGE.texture
	if not stage.has("actions") or typeof(stage.actions) != TYPE_ARRAY: 
		stage["actions"] = STAGE["actions"].duplicate()
	elif stage.actions.is_read_only(): 
		stage["actions"] = stage["actions"].duplicate()
	return stage
#endregion


func set_stage_name(new_name: String, stage_index: int) -> String:
	if _ids.has(new_name):
		new_name = "%s_%d" % [new_name, new_name.to_int() + 1]
	var old_name = _stages[stage_index].name
	_stages[stage_index].name = new_name
	_ids[stage_index] = new_name
	return old_name


func get_stage_name(stage_index: int) -> String:
	return _stages[stage_index].name


func set_stage_text(new_text: String, stage_index: int) -> void:
	_stages[stage_index].text = new_text


func get_stage_text(stage_index: int) -> String:
	return _stages[stage_index].text


func set_stage_texture(new_texture: Texture2D, stage_index: int) -> void:
	_stages[stage_index].texture = new_texture


func get_stage_texture(stage_index: int) -> Texture2D:
	return _stages[stage_index].texture


func set_stage_actions(new_actions: Array[Dictionary], stage_index: int) -> void:
	for i in new_actions.size():
		new_actions[i] = _validate_action(new_actions[i])
	_stages[stage_index].actions = new_actions


func get_stage_actions(stage_index: int) -> Array[Dictionary]:
	return _stages[stage_index].actions.duplicate()


func _validate_action(action: Dictionary) -> Dictionary:
	if action.is_empty(): 
		return ACTION_DICTIONARY.duplicate()
	if not action.has("text") or typeof(action.text) != TYPE_STRING:
		action["text"] = ACTION_DICTIONARY.text
	if not action.has("is_said") or typeof(action.is_said) != TYPE_BOOL:
		action["is_said"] = ACTION_DICTIONARY.is_said
	if not action.has("icon") or action.is_said is not Texture2D:
		action["icon"] = ACTION_DICTIONARY.icon
	if not action.has("conditions") or typeof(action.is_said) != TYPE_ARRAY:
		action["conditions"] = ACTION_DICTIONARY.conditions
	if not action.has("next_stage") or typeof(action.is_said) != TYPE_INT:
		action["next_stage"] = ACTION_DICTIONARY.next_stage
	if not action.has("action_resource") or action.is_said is not EventActionResource:
		action["action_resource"] = ACTION_DICTIONARY.action_resource
	return action


func add_action(stage_index: int, text: String, next_stage: int, is_said: bool = false, icon: Texture2D = null, 
	action_resource: EventActionResource = null, conditions: Array = []):
	var new_action := {
		"text": text,
		"is_said": is_said,
		"icon": icon,
		"conditions": conditions,
		"next_stage": next_stage,
		"action_resource": action_resource,
	}
	return set_action(new_action, stage_index)


func set_action(action: Dictionary, stage_index: int, action_index: int = -1):
	var stage = get_stage(stage_index)
	if action_index == -1:
		action_index = stage.actions.size()
		stage.actions.append(action)
	else:
		stage.actions[action_index] = action
	return action_index


func get_action(stage_index: int, action_index: int) -> Dictionary:
	return _stages[stage_index].actions[action_index]


func set_action_text(value: String, stage_index: int, action_index: int):
	get_action(stage_index, action_index).text = value


func get_action_text(stage_index: int, action_index: int) -> String:
	return get_action(stage_index, action_index).text


func set_action_is_said(value: bool, stage_index: int, action_index: int):
	get_action(stage_index, action_index).is_said = value


func get_action_is_said(stage_index: int, action_index: int) -> bool:
	return get_action(stage_index, action_index).is_said


func set_action_icon(value: Texture2D, stage_index: int, action_index: int):
	get_action(stage_index, action_index).icon = value


func get_action_icon(stage_index: int, action_index: int) -> Texture2D:
	return get_action(stage_index, action_index).icon


func set_action_conditions(value: Array, stage_index: int, action_index: int):
	get_action(stage_index, action_index).conditions = value


func get_action_conditions(stage_index: int, action_index: int) -> Array:
	return get_action(stage_index, action_index).conditions


func set_action_next_stage(value: int, stage_index: int, action_index: int):
	get_action(stage_index, action_index).next_stage = value


func get_action_next_stage(stage_index: int, action_index: int) -> int:
	return get_action(stage_index, action_index).next_stage


func set_action_resource(value: EventActionResource, stage_index: int, action_index: int):
	get_action(stage_index, action_index).action_resource = value


func get_action_resource(stage_index: int, action_index: int) -> EventActionResource:
	return get_action(stage_index, action_index).action_resource
