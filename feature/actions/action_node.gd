class_name ActionNode
extends Node

var execute_keeper: ExecuteKeeperState
var _state: ActionState


func _ready() -> void:
	_state = Injector.provide(ActionState, ActionState.new(self), self, Injector.ContainerType.CLOSEST)
	execute_keeper = Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState


func execute(action: ActionResource) -> Error:
	if not is_met_conditions(action):
		return 1
	
	for i in action.effects.size():
		execute_keeper.execute(action.effects[i])
	return OK


func is_met_conditions(action: ActionResource) -> bool:
	var result = true
	for i in action.conditions.size():
		result = result and execute_keeper.execute(action.conditions[i])
	return true 
