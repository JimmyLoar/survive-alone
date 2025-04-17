@tool
class_name EventActionNode
extends EventGraphNode


@export var line_edit: LineEdit
@export var text_edit: TextEdit


func _get_model() -> EventNode:
	return EventAction.new()


func get_edge_type(next_node: EventGraphNode) -> EventEdge.EdgeType:
	if next_node is EventConditionNode:
		return EventEdge.EdgeType.CONDITIONAL
	elif next_node is EventEffectNode:
		return EventEdge.EdgeType.EFFECT
	return EventEdge.EdgeType.ACTION


func _set_model_properties(_node: EventNode) -> void:
	_node.text_key = line_edit.text


func _get_model_properties(_node: EventNode) -> void:
	line_edit.text = _node.text_key
	_on_line_edit_text_changed(_node.text_key)


func _on_line_edit_text_changed(new_text: String) -> void:
	text_edit.text = TranslationServer.translate("ACTION_KEY_%s" % new_text.to_upper())
