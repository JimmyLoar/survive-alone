extends ItemList

@export_enum("Activated:0", "Complited:1", "All:2") var _what_show := 0


func _update_elements():
	clear()
	var quest_list = _get_quests()
	for i in quest_list.size():
		var quest: QuestResource = quest_list[i]
		add_item(quest.name)


func _get_quests() -> Array:
	match _what_show:
		0: return Questify.get_active_quests()
		1: return Questify.get_completed_quests()
		2: return Questify.get_quests()
		_: return []
