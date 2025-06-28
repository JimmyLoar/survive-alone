extends PanelContainer

signal quest_selected(quest: QuestResource)

@onready var quest_list: ItemList = %QuestList

@onready var inventory: InventoryCharacter = Locator.get_service(InventoryCharacter)

var _last_index := 0


func _ready() -> void:
	visibility_changed.connect(quest_list._update_elements)


func _on_activate_quest_list_item_selected(index: int) -> void:
	_on_quest_list_quest_selected(Questify.get_quests()[index])
	_last_index = index


func _on_quest_list_quest_selected(quest: Variant) -> void:
	quest_selected.emit(quest)
