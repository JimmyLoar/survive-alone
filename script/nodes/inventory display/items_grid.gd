class_name ItemsGrid
extends GridContainer

var button_group := ButtonGroup.new()

func _init() -> void:
	set("theme_override_constants/h_separation", 0)
	set("theme_override_constants/v_separation", 0)


func init_slots(_size := Vector2i(6, 4)):
	#button_group.allow_unpress = true
	columns = _size.x
	for i in _size.x * _size.y:
		var new_slot := InventorySlotDisplay.new()
		new_slot.pressed.connect(_on_slot_pressed.bind(i))
		new_slot.button_group = button_group
		new_slot.toggle_mode = true
		add_child(new_slot)


func update_slots(slots_list: Array):
	slots_list.resize(get_child_count())
	for i in slots_list.size():
		var value = slots_list[i] if slots_list[i] else {}
		get_child(i).update(value)


func _on_slot_pressed(slot_index: int):
	#print_debug("WOW! You press slot!")
	pass


func _on_slot_focused():
	pass
