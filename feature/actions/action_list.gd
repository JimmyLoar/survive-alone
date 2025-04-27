class_name ActionList
extends ActionAggregate


@export var _conditions: Array[ActionResource] = []
@export var _actions: Array[ActionResource] = []


func is_meet_conditions() -> bool:
	var result := true
	for resource in _conditions:
		result = result && resource.execute()
	return result


func execute() -> Array:
	if not is_meet_conditions():
		return []
	var result: Array = []
	for resource in _actions:
		result.append(resource.execute())
	return result
