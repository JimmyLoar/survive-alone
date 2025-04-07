@tool
class_name EventDialogueNode 
extends EventGraphNode 

const CHARACTERS_LIST = [
	preload("uid://k0vu08dr0tmb"),
	preload("uid://blr1yfkg5pohd"),
	preload("uid://b0cjwpa70higj"),
]

const PARAGRAPH_BOX = preload("uid://d4hi273u00176")

@export var paragraphs: HFlowContainer


func _ready() -> void:
	super()
	if not paragraphs.get_child_count():
		_add_paragrath()


func _get_model() -> EventNode:
	return EventDialogue.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for paragraph: ParagraphBox in paragraphs.get_children():
		data.append(paragraph.get_data())
	node.dialogues = data


func _get_model_properties(node: EventNode) -> void:
	for i in node.dialogues.size():
		var paragraph: ParagraphBox = _get_paragraph(i)
		paragraph.set_data.call_deferred(node.dialogues[i])


func _get_paragraph(index: int):
	if index < paragraphs.get_child_count():
		return paragraphs.get_child(index)
	return _add_paragrath()


func _add_paragrath():
	var new_paragraph: ParagraphBox = PARAGRAPH_BOX.instantiate()
	paragraphs.add_child(new_paragraph)
	new_paragraph.request_to_remove.connect(_remove_paragrath, ConnectFlags.CONNECT_ONE_SHOT)
	return new_paragraph


func _remove_paragrath(_paragraph: ParagraphBox):
	remove_child(_paragraph)
	_paragraph.queue_free()
	
	for paragraph in paragraphs:
		paragraph.update()
	
