@tool
class_name EventDialogueNode 
extends EventGraphBox 

const CHARACTERS_LIST = [
	preload("uid://lo5lkul44sou"),
	preload("uid://k0vu08dr0tmb"),
	preload("uid://blr1yfkg5pohd"),
	preload("uid://b0cjwpa70higj"),
]


func _ready() -> void:
	super()
	_add_item()


func _get_model() -> EventNode:
	return EventDialogue.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for paragraph in container.get_children():
		data.append(paragraph._get_data())
	node.dialogues = data


func _get_model_properties(node: EventNode) -> void:
	for i in node.dialogues.size():
		var paragraph = _get_item(i)
		paragraph._set_data.call_deferred(node.dialogues[i])
