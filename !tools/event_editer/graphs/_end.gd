@tool
class_name EventEndNode
extends EventGraphNode


func _get_model() -> EventNode:
	return EventEnd.new()


func _set_model_properties(_node: EventNode) -> void:
	pass


func _get_model_properties(_node: EventNode) -> void:
	pass
