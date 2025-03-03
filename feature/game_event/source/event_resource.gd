@tool
class_name EventResource
extends NamedResource

enum Tags{
	nothing, 		#ничего
	trees, 			#деревья
	water, 			#вода
	flower,			#цветы
	berries,		#ягоды
	mushrooms, 		#грибы
	plants,			#травы
	herbivorous,	#травоядные жевотные
	carnivores,		#хищьники
	large_animals, 	#крупные звери
	small_animals, 	#небольшие звери
	ruins,  		#руины
	location,		#локация
}

@export var _stages: Array[EventStageResource] = []
var _ids: PackedStringArray = []


func _init(_name: String = "", stages_count: int = 1) -> void:
	super("EVENT")
	code_name = _name


#region Stage
func add_stage(_name: String, text: String= "", texture: Texture2D = null) -> int:
	var stage := EventStageResource.new()
	stage.name = _name
	stage.text = text
	stage.texture = texture
	var action = ActionResource.new()
	action.code_name = "..."
	stage.actions = [action]
	return set_stage(stage)


func set_stage(stage_data: EventStageResource, stage_id: int = -1) -> int:
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


func get_full_data() -> Array[EventActionResource]:
	return _stages.duplicate()


func _get_new_stage() -> EventActionResource:
	return EventActionResource.new()


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


func set_stage_actions(new_actions: Array[EventActionResource], stage_index: int) -> void:
	_stages[stage_index].actions = new_actions


func get_stage_actions(stage_index: int) -> Array[Dictionary]:
	return _stages[stage_index].actions.duplicate()


func add_action(stage_index: int, text: String, next_stage: int, is_said: bool = false, icon: Texture2D = null, 
	conditions: Array[ExecuteKeeperResource] = [], effects: Array[ExecuteKeeperResource] = []):
	var new_action := EventActionResource.new()
	new_action.code_name = text
	new_action.is_said = is_said
	new_action.icon = icon
	new_action.next_stage = next_stage
	new_action.set_conditions(conditions)
	new_action.set_effects(effects)
	return set_action(new_action, stage_index)


func set_action(action: EventActionResource, stage_index: int, action_index: int = -1):
	var stage = get_stage(stage_index)
	if action_index == -1:
		action_index = stage.actions.size()
		stage.actions.append(action)
	else:
		stage.actions[action_index] = action
	return action_index


func get_action(stage_index: int, action_index: int) -> EventActionResource:
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


func set_action_resource(value: ActionResource, stage_index: int, action_index: int):
	get_action(stage_index, action_index).action_resource = value


func get_action_resource(stage_index: int, action_index: int) -> ActionResource:
	return get_action(stage_index, action_index).action_resource
