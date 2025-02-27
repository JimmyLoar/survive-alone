extends ItemList

@onready var action_state: ActionState

func update_actions(actions: Array[EventActionResource]):
	self.clear()
	self.max_columns = ceil(actions.size() / 3.0)
	for i in actions.size():
		var action := actions[i] as EventActionResource
		var brackets: String = '"%s"' if action.is_said else "[%s]"
		var index = self.add_item(
			brackets % action.visible_name,
			action.icon,
		)
		self.set_item_disabled(index, not action_state.can_execute(action))
