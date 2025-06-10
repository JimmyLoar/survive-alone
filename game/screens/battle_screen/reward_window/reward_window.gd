class_name RewardDialog extends Window

const EMPTY_REWARD_Y_SIZE = 34
const LOW_REWARD_Y_SIZE = 158
const MORE_REWARD_Y_SIZE = 266

@onready var item_list: ItemList = $VBoxContainer/PanelContainer/ScrollContainer/ItemList


func set_items(items: Array[ItemEntity]):
	item_list.clear()
	if items.is_empty():
		size.y = EMPTY_REWARD_Y_SIZE
		return
	
	for i in items:
		var resource = i.get_resource() as ItemResource
		item_list.add_item(resource.code_name, resource.texture, false)
	size.y = MORE_REWARD_Y_SIZE if items.size() > 5 else LOW_REWARD_Y_SIZE


func show_result(title_text: String):
	title = title_text
	show()


func _on_button_pressed() -> void:
	close_requested.emit()
