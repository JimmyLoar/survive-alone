class_name ItemActionState
extends ActionState


var _get_name: Callable = func(item: ItemEntity): 
	return item.get_resource().code_name 

var last_entity: ItemEntity

#region PublicFunction
func can_execute(action_entity: ActionResource) -> bool:
	if action_entity is not ItemActionResource:
		_logger.warn("Can not execute ")
		return false
	
	var result := true
	return result and super.can_execute(action_entity)


func execute(action_entity: ActionResource) -> void:
	super(action_entity)
	if action_entity.has_type(ItemActionResource.ACTION_DECREASE_WHEN_ACTIVATE):
		last_entity.decrease_total_amount(1)

#endregion
