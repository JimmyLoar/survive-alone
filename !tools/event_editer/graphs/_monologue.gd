@tool
class_name EventMonologueNode
extends EventGraphNode


@export var line_edit: LineEdit
@export var text_edit: TextEdit


func get_edge_type(next_node: EventGraphNode) -> EventEdge.EdgeType:
	if next_node is EventActionNode:
		return EventEdge.EdgeType.ACTION
	return EventEdge.EdgeType.NORMAL


func _get_model() -> EventNode:
	return EventMonologue.new()


func _set_model_properties(node: EventNode) -> void:
	node.text = line_edit.text


func _get_model_properties(node: EventNode) -> void:
	line_edit.text = node.text
	_on_line_edit_text_changed(node.text)


func _on_line_edit_text_changed(new_text: String) -> void:
	text_edit.text = TranslationServer.translate(("event_monologue_%s" % new_text).to_upper())
