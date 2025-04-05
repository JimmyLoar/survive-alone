class_name EventState
extends Injectable

var _node: EventDisplay


func _init(_new_node: EventDisplay) -> void:
	_node = _new_node


func start_event(event: EventResource):
	_node.display(event)
	
