@tool
class_name EventConditionNode
extends EventGraphBox


func get_edge_type(next_node: EventGraphNode) -> EventEdge.EdgeType:
	return EventEdge.EdgeType.CONDITIONAL


func _get_model() -> EventNode:
	return EventCondition.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for condition in container.get_children():
		data.append(condition._get_data())
	node.conditions.assign(data)


func _get_model_properties(node: EventNode) -> void:
	for i in node.conditions.size():
		var condition = _get_item(i)
		condition._set_data.call_deferred(node.conditions[i])
