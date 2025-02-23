class_name EventActionState
extends ActionState




func can_execute(action_entity: ActionResource) -> bool:
	if action_entity is not EventActionResource:
		_logger.warn("Can not execute ")
		return false
	
	var result := true
	if action_entity.has_type(EventActionResource.ACTION_START_EVENT):
		result = result and not action_entity.events_list.is_empty()
	
	return result and super.can_execute(action_entity)


func execute(action_entity: ActionResource) -> void:
	super(action_entity)
	if action_entity.has_type(EventActionResource.ACTION_START_EVENT):
		pass
	
