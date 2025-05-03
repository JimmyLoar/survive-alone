extends ItemList

signal quest_selected(quest: QuestResource)

@export_enum("Activated:0", "Complited:1", "All:2") var what_show := 0


var _quests := []

func _ready() -> void:
	item_selected.connect(_on_pressed)


func _update_elements():
	clear()
	_quests.clear()
	_append_list("Activated", Questify.get_active_quests())
	_append_list("Complited", Questify.get_completed_quests())


func _append_list(title: String, list: Array):
	if list.is_empty():
		return
	
	var title_index := add_item(title, null, false)
	set_item_disabled(title_index, true)
	
	_quests.append(title)
	_quests.append_array(list)
	
	for i in list.size():
		var quest: QuestResource = list[i]
		@warning_ignore_start('unused_variable')
		var index := add_item(quest.name)


func _on_pressed(index: int):
	quest_selected.emit(_quests[index])
