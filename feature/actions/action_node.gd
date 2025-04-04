class_name ActionNode
extends Node

var execute_keeper: ExecuteKeeperState
var _state: ActionState


func _ready() -> void:
	_state = Injector.provide(ActionState, ActionState.new(self), self, Injector.ContainerType.CLOSEST)
	execute_keeper = Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState


func execute(action: ActionResource) -> Dictionary:
	var result: Dictionary = {}
	for effect in action.effects:
		result[effect] = execute_keeper.execute(effect)
	return result


func is_met_conditions(action: ActionResource) -> bool:
	if action.conditions.is_empty():
		return true
	
	for i in action.conditions.size():
		if not await execute_keeper.execute(action.conditions[i]):
			return false
	return true 
