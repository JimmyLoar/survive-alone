@tool
class_name EventStartNode 
extends EventGraphNode


var event_name: String
var event_discription: String

@export var name_text_edit: LineEdit 
@export var name_translated: TextEdit
@export var discription_translated: TextEdit


func _get_model() -> EventNode:
	return EventStart.new()


func _set_model_properties(node: EventNode) -> void:
	node.name_key = event_name


func _get_model_properties(node: EventNode) -> void:
	name_text_edit.text = node.name_key
	_on_name_text_edit_text_changed(node.name_key)


func _on_name_text_edit_text_changed(new_text: String) -> void:
	event_name = new_text.to_lower()
	name_translated.text = TranslationServer.translate(("%s_name" % event_name).to_upper())
	discription_translated.text = TranslationServer.translate(("%s_discription" % event_name).to_upper())
	EventsGlobal.event_name = event_name
