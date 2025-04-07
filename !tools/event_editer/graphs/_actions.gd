@tool
class_name EventActionsNode
extends EventGraphNode


func _get_model() -> EventNode:
	return ActionsEventNode.new()


func _set_model_properties(_node: EventNode) -> void:
	pass


func _get_model_properties(_node: EventNode) -> void:
	pass
