@tool
class_name EventAbortNode
extends EventGraphNode



func _get_model() -> EventNode:
	return EventAbort.new()


func _set_model_properties(_node: EventNode) -> void:
	pass


func _get_model_properties(_node: EventNode) -> void:
	pass
