@tool
class_name EventEndNode
extends EventGraphNode


@export var type_label: Label 
@export var type_option_button: OptionButton
@export var name_label: Label
@export var name_option_button: OptionButton


func _get_model() -> EventNode:
	return EventEnd.new()


func _set_model_properties(_node: EventNode) -> void:
	_node.next_type = type_option_button.selected
	_node.next_name = name_option_button.get_item_text(name_option_button.selected)
	


func _get_model_properties(_node: EventNode) -> void:
	type_option_button.select(_node.next_type)
	_on_type_option_button_item_selected(_node.next_type)
	var list: Dictionary = [{}, ResourceCollector.quests, ResourceCollector.events][type_option_button.selected]
	var index = list.keys().find(_node.next_name)
	name_option_button.select(index)
	name_option_button.visible = _node.next_type != EventEnd.Next.NONE


func _on_type_option_button_item_selected(index: int) -> void:
	name_label.visible = index != 0
	name_option_button.visible = index != 0
	name_option_button.clear()
	var list: Dictionary = [{}, ResourceCollector.quests, ResourceCollector.events][type_option_button.selected]
	for item in list.keys():
		name_option_button.add_item(item)
