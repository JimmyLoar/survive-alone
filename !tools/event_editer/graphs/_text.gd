@tool
class_name EventMonologueNode
extends EventGraphNode


@export var text_box: PhraseBox


func _get_model() -> EventNode:
	return EventText.new()


func _set_model_properties(node: EventNode) -> void:
	node.text = text_box.get_data()


func _get_model_properties(node: EventNode) -> void:
	text_box.set_data(node.text)
