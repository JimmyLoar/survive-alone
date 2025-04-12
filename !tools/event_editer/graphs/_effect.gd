@tool
class_name EventEffectNode
extends EventGraphBox


func _get_model() -> EventNode:
	return EventEffect.new()


func _set_model_properties(node: EventNode) -> void:
	var data := Array()
	for effect in container.get_children():
		data.append(effect._get_data())
	node.effects.assign(data)


func _get_model_properties(node: EventNode) -> void:
	for i in node.effects.size():
		var effect = _get_item(i)
		effect._set_data.call_deferred(node.effects[i])


func _on_add_button_pressed() -> void:
	_add_item()
