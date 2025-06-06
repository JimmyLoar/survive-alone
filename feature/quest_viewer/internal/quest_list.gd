extends PanelContainer

signal quest_selected(quest: QuestResource)

@onready var quest_list: ItemList = %QuestList

@onready var inventory: InventoryCharacterState = Locator.get_service(InventoryCharacterState)

var _last_index := 0


func _ready() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	visibility_changed.connect(quest_list._update_elements)


func _on_activate_quest_list_item_selected(index: int) -> void:
	_on_quest_list_quest_selected(Questify.get_quests()[index])
	_last_index = index


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	if type == "item":
		var result = inventory.has_item_amount(key, value)
		requester.set_completed(result)
		if result:
			inventory.remove_item(key, value)
	


func _on_quest_list_quest_selected(quest: Variant) -> void:
	quest_selected.emit(quest)
