@tool
class_name StageEventGraphNode
extends EventGraphNode

func _get_model() -> EventNode:
	return StageEventNode.new()
	
	
func _set_model_properties(_node: EventNode) -> void:
	pass
	
	
func _get_model_properties(_node: EventNode) -> void:
	pass
