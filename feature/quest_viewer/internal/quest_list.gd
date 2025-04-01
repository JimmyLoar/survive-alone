extends PanelContainer

signal quest_selected(quest: QuestResource)

@onready var activate_quest_list: ItemList = %ActivateQuestList
@onready var complite_quest_list: ItemList = %CompliteQuestList

@onready var inventory: InventoryCharacterState = Injector.inject(InventoryCharacterState, self)

func _ready() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	visibility_changed.connect(activate_quest_list._update_elements)
	visibility_changed.connect(complite_quest_list._update_elements)


func _on_activate_quest_list_item_selected(index: int) -> void:
	quest_selected.emit(Questify.get_active_quests()[index])


func _on_complite_quest_list_item_selected(index: int) -> void:
	quest_selected.emit(Questify.get_completed_quests()[index])


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	if type == "item":
		var result = inventory.has_item_amount(key, value)
		requester.set_completed(result)
		if result:
			inventory.remove_item(key, value)
