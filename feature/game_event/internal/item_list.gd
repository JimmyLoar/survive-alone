extends ItemList

func update_result(action: ActionResource):
	clear()
	for effect: ExecuteKeeperResource in action.effects:
		if effect.name.contains("item") or effect.name.contains("property"):
			var args = effect.args_data as Array
			var text = ""
			var icon = null
			add_item(str(text), )
	
	self.visible = item_count > 0


func append_result(data: Dictionary):
	var index = 
