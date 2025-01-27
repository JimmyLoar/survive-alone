class_name ItemContainer
extends Button

var display: ItemDisplay
var current_item: ItemEntity = null

func _init() -> void:
	set("theme_override_styles/disabled", preload("res://assets/themes/buttons/default-normal.tres"))
	set("theme_override_styles/hover", preload("res://assets/themes/buttons/default-hover.tres"))
	set("theme_override_styles/pressed", preload("res://assets/themes/buttons/default-pressed.tres"))
	set("theme_override_styles/hover_pressed", preload("res://assets/themes/buttons/default-pressed.tres"))
	set("theme_override_styles/normal", preload("res://assets/themes/buttons/default-normal.tres"))
	
	set("theme_override_styles/disabled_mirrored", preload("res://assets/themes/buttons/default-normal.tres"))
	set("theme_override_styles/hover_mirrored", preload("res://assets/themes/buttons/default-hover.tres"))
	set("theme_override_styles/pressed_mirrored", preload("res://assets/themes/buttons/default-pressed.tres"))
	set("theme_override_styles/hover_pressed_mirrored", preload("res://assets/themes/buttons/default-pressed.tres"))
	set("theme_override_styles/normal_mirrored", preload("res://assets/themes/buttons/default-normal.tres"))
	set("focus_mode", FOCUS_NONE)
	
	set("size_flags_horizontal", SIZE_EXPAND_FILL)
	set("size_flags_vertical", SIZE_EXPAND_FILL)
	
	display = preload("res://feature/items/item_display.tscn").instantiate()
	add_child(display)
	display.hide()


func update(item: ItemEntity):
	if item != current_item:
		if item:
			item.changed_amount.connect(display.update_amount)
		if current_item:
			current_item.changed_amount.disconnect(display.update_amount)
		current_item = item
	
	_display(item)


func _display(item):
	if not item or item.get_total_amount() == 0:
		_display_empty()
	
	else:
		_display_item(item)


func _display_empty():
	disabled = true
	display.hide()
	current_item = null


func _display_item(item: ItemEntity):
	disabled = false
	display.update_data(item.get_resource())
	display.update_amount(item.get_total_amount())
	display.show()
