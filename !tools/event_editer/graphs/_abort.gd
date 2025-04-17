@tool
class_name EventAbortNode
extends EventGraphNode


func get_edge_type(next_node: EventGraphNode) -> EventEdge.EdgeType:
	if next_node is EventActionNode:
		return EventEdge.EdgeType.ACTION
	return EventEdge.EdgeType.NORMAL


func _get_model() -> EventNode:
	return EventAbort.new()


func _set_model_properties(_node: EventNode) -> void:
	pass


func _get_model_properties(_node: EventNode) -> void:
	pass
