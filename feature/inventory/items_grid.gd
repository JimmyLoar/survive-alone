class_name SlotCotroller
extends GridContainer

signal item_pressed(item_index: int)
signal duble_pressed(item_index:int)

var button_group := ButtonGroup.new()
@onready var logger = GodotLogger.with('SlotCotroller')


func _init() -> void:
	set("theme_override_constants/h_separation", 0)
	set("theme_override_constants/v_separation", 0)


func init_items(_size := Vector2i(6, 4)):
	#button_group.allow_unpress = true
	columns = _size.x
	for i in _size.x * _size.y:
		var new_item := InventorySlotDisplay.new()
		new_item.pressed.connect(_on_item_pressed.bind(i))
		new_item.button_group = button_group
		new_item.toggle_mode = true
		add_child(new_item)


func update_items(items_list: Array):
	items_list.resize(get_child_count())
	for i in items_list.size():
		var value = items_list[i] if items_list[i] else null
		var child = get_child(i)
		child.update(value)


var timer: SceneTreeTimer
func _on_item_pressed(item_index: int):
	logger.debug("Pressed %d items." % item_index)
	item_pressed.emit(item_index)
	
	if timer and timer.time_left > 0:
		_duble_click(item_index)
		return
	
	timer = get_tree().create_timer(0.3)


func _duble_click(item_index: int):
	logger.debug("Duble pressed on %d" % item_index)
	duble_pressed.emit(item_index)


func _on_item_focused():
	pass
