@tool
class_name DialogeEventGraphNode 
extends EventGraphNode 

const CHARACTERS_LIST = [
	preload("uid://blr1yfkg5pohd"),
	preload("uid://b0cjwpa70higj"),
	preload("uid://b0cjwpa70higj"),
]

const PARAGRAPH_BOX = preload("res://!tools/event_editer/graphs/internal/paragraph_box.tscn")

@export var paragraphs: HFlowContainer


func _get_model() -> EventNode:
	return DialogeEventNode.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for paragraph: ParagrathBox in paragraphs.get_children():
		data.append(paragraph.get_data())
	node.dialoges = data
	


func _get_model_properties(node: EventNode) -> void:
	for i in node.dialoges.size():
		var paragraph: ParagrathBox = _get_paragraph(i)
		paragraph.set_data(node.dialoges[i])


func _get_paragraph(index: int):
	if index <= paragraphs.get_child_count():
		return paragraphs.get_child(index)
	return _add_paragrath()


func _add_paragrath():
	var new_paragraph := PARAGRAPH_BOX.instantiate()
	paragraphs.add_child(new_paragraph)
	new_paragraph.request_to_remove.connect(_remove_paragrath, ConnectFlags.CONNECT_ONE_SHOT)
	return new_paragraph


func _remove_paragrath(_paragraph: ParagrathBox):
	remove_child(_paragraph)
	_paragraph.queue_free()
	
	for paragraph in paragraphs:
		paragraph.update()
	
