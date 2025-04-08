class_name EventStage
extends EventNode


var actions: Array[EventAction]:
	get:
		return _graph.get_next_actions(self)


func get_active() -> bool:
	if get_completed():
		return false
	return all_previous_nodes_completed() and not any_children_active()


func update() -> void:
	var just_completed := false
	if get_active():
		for action in actions:
			action.update()
			if not action.get_completed():
				return
		completed = true
		just_completed = true
	super()
	# mark objective as completed AFTER the updates in next nodes
	# this is necessary for Conditional Branch node to work
	if just_completed:
		_graph.complete_stage(self)
