class_name ItemAction
extends Node


var currect_action: ItemActionEntity

@onready var state: ItemActionState = %ItemActionState

@onready var properties_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertiesContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider

@onready var need_label: Label = %NeedLabel
@onready var need_slot_cotroller: ItemsGrid = %NeedSlotCotroller
@onready var reward_label: Label = %RewardLabel
@onready var reward_slot_cotroller: ItemsGrid = %RewardSlotCotroller


func display(action: ItemActionEntity):
	currect_action = action
	if currect_action.get_values().has(&"properties"):
		_display_properties(currect_action.get_values().properties)
	
	elif false:
		_display_items_grids()
	
	slider.visible = action.use_stack


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


func _display_items_grids():
	pass


func _on_button_pressed() -> void:
	if state.can_execute(currect_action):
		state.execute(currect_action)
