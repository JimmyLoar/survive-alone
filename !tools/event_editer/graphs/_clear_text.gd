@tool
class_name ClearTextNode
extends EventGraphNode


func _get_model() -> EventNode:
	return EventClearText.new()


func _set_model_properties(node: EventNode) -> void:
	pass


func _get_model_properties(node: EventNode) -> void:
	pass
