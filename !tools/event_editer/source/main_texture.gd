class_name EventMainTexture
extends EventNode

@export var texture: String


func get_active() -> bool:
	if get_completed():
		return false
	return all_previous_nodes_completed() and not any_children_active()
