class_name InventorySlotDisplay
extends Button

var display: ItemDisplay
var current_slot: InventorySlot = null

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


func update(slot: InventorySlot):
	if slot != current_slot:
		if slot:
			slot.connect("changed", Callable(self, "_on_slot_changed"))
		if current_slot:
			current_slot.disconnect("changed", Callable(self, "_on_slot_changed"))
		current_slot = slot
	
	_display(slot)

		
func _display(slot):
	if not slot or slot.is_empty():
		_display_empty()
	
	else:
		_display_slot(slot)

func _display_empty():
	disabled = true
	display.hide()
	current_slot = null
	


func _display_slot(slot: InventorySlot):
	disabled = false
	display.update_data(slot.get_data())
	display.update_amount(slot.get_total_amount())
	display.show()
	

func _on_slot_changed(_never):
	_display(current_slot)
