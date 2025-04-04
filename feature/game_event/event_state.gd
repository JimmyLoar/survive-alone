class_name EventState
extends Injectable

var _node: EventNode




func _init(_new_node: EventNode) -> void:
	_node = _new_node


func activate_event(event: EventResource):
	_node.display(event)


func  start_event(event: EventResource):
	pass
