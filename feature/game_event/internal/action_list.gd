extends ItemList


func update_actions(actions: Array[EventAction]):
	self.clear()
	self.max_columns = ceil(actions.size() / 3.0)
	for i in actions.size():
		var action := actions[i] as EventAction
		var brackets: String = '"%s"' if action.is_said else "[%s]"
		var index = self.add_item(
			brackets % action.text_key,
			#action.icon,
		)
		#var is_disable = not await(action_state.can_execute(action))
		self.set_item_disabled(index, action.get_meta("disabled"))
