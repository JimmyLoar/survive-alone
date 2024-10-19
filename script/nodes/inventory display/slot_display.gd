class_name InventorySlotDisplay
extends Button

var display: ItemDisplay

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
	
	display = preload("res://scenes/ui/inventory/item_display.tscn").instantiate()
	add_child(display)
	display.hide()


func update(inventory_slot: Dictionary):
	if not inventory_slot or inventory_slot.is_empty():
		disabled = true
		display.hide()
		return
	
	disabled = false
	display.update_data(inventory_slot.item)
	display.update_amount(inventory_slot.used.size() + inventory_slot.amount)
	display.show()
