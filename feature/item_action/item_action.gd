class_name ItemAction
extends Node


var currect_action: ItemActionResource

@onready var state: ItemActionState = %ItemActionState

@onready var properties_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertiesContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider

@onready var need_label: Label = %NeedLabel
@onready var need_slot_cotroller: ItemsGrid = %NeedSlotCotroller
@onready var reward_label: Label = %RewardLabel
@onready var reward_slot_cotroller: ItemsGrid = %RewardSlotCotroller
@onready var items_container: VBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer

@onready var button: Button = $MarginContainer/VBoxContainer/Button


const _VALUE = { #0 - func_name #1 - container varible #2 - data key
	ItemActionResource.Types.CHANGE_PROPERTY: 	["_display_properties", "properties_container", &"properties"],
	ItemActionResource.Types.NEED_ITEMS: 		["_display_need_items_grids", "items_container", &"need_items"],
	ItemActionResource.Types.REWARD_ITEMS: 		["_display_reward_items_grids", "items_container", &"reward_items"],
}

func display(action: ItemActionResource):
	currect_action = action
	_update_action_types(action)
	slider.visible = action.use_stack
	button.text = action.name_key


func _update_action_types(action: ItemActionResource):
	var _values := action.get_values() as Dictionary
	for type in _VALUE.keys():
		var array = _VALUE[type]
		var container: Control = get(array[1])
		if action.has_type(type):
			call(array[0], _values[array[2]])
			container.show()
		
		else:
			container.hide()


func _display_properties(properties: Dictionary):
	var _names := properties.keys()
	var _values := properties.values()
	for i in 6:
		var property_value = properties_container.get_child(i)
		if _names.size() <= i or _values[i] == 0:
			property_value.hide()
			continue
		
		property_value.update_data(_names[i])
		property_value.update_value(_values[i])
		property_value.show()


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
@onready var resource_db := Injector.inject(ResourceDb, self) as ResourceDb
func _get_item_entities(items: Dictionary) -> Array[ItemEntity]:
	var database: Database = resource_db.connection
	var array: Array[ItemEntity] = []
	for _name in items:
		if items[_name] == 0:
			continue
		var item_resource: ItemResource = database.fetch_data(&"items", StringName(_name))
		array.append(ItemEntity.new(item_resource, items[_name]))
	return array


func _on_button_pressed() -> void:
	if state.can_execute(currect_action):
		state.execute(currect_action)
