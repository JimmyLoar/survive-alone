@tool
class_name DialogeEventGraphNode 
extends EventGraphNode 

const CHARACTERS_LIST = [
	preload("uid://blr1yfkg5pohd"),
	preload("uid://b0cjwpa70higj"),
	preload("uid://b0cjwpa70higj"),
]

const PARAGRAPH_BOX = preload("res://!tools/event_editer/graphs/internal/paragraph_box.tscn")

@onready var paragraphs: HFlowContainer = %Paragraphs


func _get_model() -> EventNode:
	return DialogeEventNode.new()


func _set_model_properties(node: EventNode) -> void:
	node.dialoges.clear()
	for paragraph: ParagrathBox in paragraphs:
		node.dialoges.append(paragraph.get_data())


func _get_model_properties(node: EventNode) -> void:
	for i in node.dialoges.size():
		var paragraph: ParagrathBox = paragraphs.get_child(i)
		if not paragraph:
			paragraph = _add_paragrath()
		paragraph.set_data(node.dialoges[i])


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
	
