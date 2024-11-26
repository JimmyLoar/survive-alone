class_name SlotCotroller
extends GridContainer

signal slot_pressed(slot_index: int)
signal duble_pressed(slot_index:int)

var button_group := ButtonGroup.new()
@onready var logger = GodotLogger.with('SlotCotroller')


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
	logger.debug("Done init slots.")


func update_slots(slots_list: Array):
	slots_list.resize(get_child_count())
	for i in slots_list.size():
		var value = slots_list[i] if slots_list[i] else null
		get_child(i).update(value)
	logger.debug("Done update slots.")

var timer: SceneTreeTimer
func _on_slot_pressed(slot_index: int):
	logger.debug("Pressed %d slots." % slot_index)
	slot_pressed.emit(slot_index)
	
	if timer and timer.time_left > 0:
		_duble_click(slot_index)
		return
	
	timer = get_tree().create_timer(0.3)


func _duble_click(slot_index: int):
	logger.debug("Duble pressed on %d" % slot_index)
	duble_pressed.emit(slot_index)


func _on_slot_focused():
	pass
