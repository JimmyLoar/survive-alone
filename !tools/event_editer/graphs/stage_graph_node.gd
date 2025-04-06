@tool
class_name StageEventGraphNode
extends EventGraphNode

@export var line_edit: LineEdit
@export var text_edit: TextEdit


func _get_model() -> EventNode:
	return StageEventNode.new()


func _set_model_properties(node: EventNode) -> void:
	node.text = line_edit.text


func _get_model_properties(node: EventNode) -> void:
	line_edit.text = node.text
	_on_line_edit_text_changed(node.text)


func _on_line_edit_text_changed(new_text: String) -> void:
	text_edit.text = TranslationServer.translate(("event_stage_%s" % new_text).to_upper())
