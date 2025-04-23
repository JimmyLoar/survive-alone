class_name ActionNode
extends Node

var execute_keeper: ExecuteKeeperState
var _state: ActionState


func _ready() -> void:
	_state = Locator.initialize_service(ActionState, [self])
	execute_keeper = Locator.get_service(ExecuteKeeperState) as ExecuteKeeperState
