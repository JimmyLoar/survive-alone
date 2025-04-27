class_name ActionList
extends ActionAggregate

@export var _action_name: String = 'action'
@export var conditions: Array[ActionResource] = []
@export var actions: Array[ActionResource] = []


func is_meet_conditions() -> bool:
	var result := true
	for resource in conditions:
		result = result && resource.execute()
	return result


func execute() -> Array:
	if not is_meet_conditions():
		return []
	var result: Array = []
	for resource in actions:
		result.append(resource.execute())
	return result


func get_action_name():
	return _action_name
