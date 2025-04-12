@tool
class_name EventConditionNode
extends EventGraphBox

const CONDITION_SCENE = preload("uid://cogm42f2tx5jn")

@export var condition_box: VBoxContainer


func _get_model() -> EventNode:
	return EventCondition.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for condition: Condition in condition_box.get_children():
		data.append(condition.get_data())
	node.conditions.assign(data)


func _get_model_properties(node: EventNode) -> void:
	for i in node.conditions.size():
		var condition: Condition = _get_item(i)
		condition.set_data.call_deferred(node.conditions[i])


func _on_add_button_pressed() -> void:
	_add_item()
