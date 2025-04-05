@tool
class_name EndEventGraphNode
extends EventGraphNode

func _get_model() -> EventNode:
	return EndEventNode.new()


func _set_model_properties(_node: EventNode) -> void:
	pass


func _get_model_properties(_node: EventNode) -> void:
	pass
