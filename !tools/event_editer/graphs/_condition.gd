@tool
class_name EventConditionNode
extends EventGraphNode

const CONDITION_SCENE = preload("uid://cogm42f2tx5jn")

@export var condition_box: VBoxContainer


func _ready() -> void:
	super()
	_add_condition()


func _child_update():
	for condition in condition_box.get_children():
		condition.update() 


func _get_model() -> EventNode:
	return EventCondition.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for condition: Condition in condition_box.get_children():
		data.append(condition.get_data())
	node.conditions.assign(data)
	#printerr(data.map(func(arr): return arr[0].name))


func _get_model_properties(node: EventNode) -> void:
	for i in node.conditions.size():
		var condition: Condition = _get_condition(i)
		condition.set_data.call_deferred(node.conditions[i])


func _get_condition(index: int) -> Condition:
	if index < condition_box.get_child_count():
		return condition_box.get_child(index)
	return _add_condition()


func _add_condition():
	var new_condition = CONDITION_SCENE.instantiate() as Condition
	condition_box.add_child(new_condition)
	new_condition.request_to_remove.connect(_remove_condition.bind(new_condition))
	_child_update()
	return new_condition



func _remove_condition(_condition: Condition):
	condition_box.remove_child(_condition)
	_condition.queue_free()
	_child_update()

func _on_add_button_pressed() -> void:
	_add_condition()
