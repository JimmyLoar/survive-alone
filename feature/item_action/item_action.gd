class_name ItemAction
extends Control


var currect_action: ActionAggregate


@onready var properties_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertiesContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider

@onready var need_label: Label = %NeedLabel
@onready var need_slot_cotroller: ItemsGrid = %NeedSlotCotroller
@onready var reward_label: Label = %RewardLabel
@onready var reward_slot_cotroller: ItemsGrid = %RewardSlotCotroller
@onready var items_container: VBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer

@onready var button: Button = $MarginContainer/VBoxContainer/Button



func display(action: ActionAggregate):
	currect_action = action
	button.text = action.get_action_name()
	_update_action_types()


func _update_action_types():
	_display_properties()
	self.show()


func _display_properties():
	var _properties_index: int = 0
	var _action_resources: Array = []
	for _name in currect_action.get_methods_names():
		if _name == "property_add_value":
			var args := currect_action.get_arguments_to_method(_name)
			_display_property_bar(_properties_index, args[0], args[1])
			_properties_index += 1
	
	for action: ActionResource in currect_action.addational_actions:
		if action._method_name == "property_add_value":
			var args = action.get_arguments()
			_display_property_bar(_properties_index, args[0], args[1])
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
	currect_action.execute()
