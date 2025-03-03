class_name ActionState
extends Injectable


var last_item: ItemEntity


var _logger: Log
var _node : ActionNode


func _init(new_node: ActionNode) -> void:
	_logger = Log.get_global_logger().with("ActionState")
	_node = new_node


func can_execute(action_resource: ActionResource) -> bool:
	if not action_resource: 
		return false
	return await _node.is_met_conditions(action_resource)


func execute(action_resource: ActionResource) -> Dictionary:
	return _node.execute(action_resource)
