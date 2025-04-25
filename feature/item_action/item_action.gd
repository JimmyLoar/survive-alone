class_name ItemAction
extends Control


var currect_action: ActionResource


@onready var properties_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertiesContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider

@onready var need_label: Label = %NeedLabel
@onready var need_slot_cotroller: ItemsGrid = %NeedSlotCotroller
@onready var reward_label: Label = %RewardLabel
@onready var reward_slot_cotroller: ItemsGrid = %RewardSlotCotroller
@onready var items_container: VBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer

@onready var button: Button = $MarginContainer/VBoxContainer/Button
@onready var action_state: ActionState = Locator.get_service(ActionState)



func display(action: ActionResource):
	currect_action = action
	button.text = action.visible_name
	_update_action_types()


func _update_action_types():
	if currect_action.context_show_properties_bar:
		_display_properties()
	else:
		for i in range(6):
			properties_container.get_child(i).hide()
	self.show()


func _display_properties():
	var _properties_index: int = 0
	for i in currect_action.effects.size():
		var effect: ExecuteKeeperResource = currect_action.effects[i] 
		if effect.name.contains("property"):
			_display_property_bar(_properties_index, effect.args_data[0], effect.args_data[1])
			_properties_index += 1
	
	for i in range(_properties_index, 6):
		properties_container.get_child(i).hide()


func _display_need_items_grids(items: Dictionary):
	need_slot_cotroller.reset_items_slots(Vector2i(6, ceil(items.size() / 6.0)))
	need_slot_cotroller.display_mode = 0
	var entity = _get_item_entities(items) as Array[ItemEntity]
	need_slot_cotroller.update_items_list(entity)


func _display_reward_items_grids(items: Dictionary):
	reward_slot_cotroller.reset_items_slots(Vector2i(6, ceil(items.size() / 6.0)))
	reward_slot_cotroller.display_mode = 0
	var entity = _get_item_entities(items) as Array[ItemEntity]
	reward_slot_cotroller.update_items_list(entity)


# TODO найти более подходящие место для функции ниже
@onready var resource_db := Locator.get_service(ResourceDb) as ResourceDb
func _get_item_entities(items: Dictionary) -> Array[ItemEntity]:
	var database: Database = resource_db.connection
	var array: Array[ItemEntity] = []
	for _name in items:
		if items[_name] == 0:
			continue
		var item_resource: ItemResource = database.fetch_data(&"items", StringName(_name))
		array.append(ItemEntity.new(item_resource, items[_name]))
	return array


func _display_property_bar(index: int, property_name: String, value: int):
	var property_bar := properties_container.get_child(index)
	property_bar.update_data(property_name)
	property_bar.update_value(value)
	property_bar.show()


func _on_button_pressed() -> void:
	if await action_state.can_execute(currect_action):
		action_state.execute(currect_action)
