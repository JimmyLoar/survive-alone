class_name ItemsGrid
extends GridContainer

signal item_pressed(item_index: int)
signal duble_pressed(item_index:int)

@export var _init_size: Vector2i = Vector2i(6, 4): 
	set(value): 
		_init_size = value.max(Vector2i(1, 1))

var button_group := ButtonGroup.new()
var timer: SceneTreeTimer

@onready var logger = Log.get_global_logger().with('ItemGrid')


func _init() -> void:
	set("theme_override_constants/h_separation", 0)
	set("theme_override_constants/v_separation", 0)
	init_items(_init_size)


func init_items(_size: Vector2i):
	#button_group.allow_unpress = true
	_clear_items()
	columns = _size.x
	for i in _size.x * _size.y:
		var new_item := ItemContainer.new()
		new_item.pressed.connect(_on_item_pressed.bind(i))
		new_item.button_group = button_group
		new_item.toggle_mode = true
		add_child(new_item)


func update_items_list(list: Array[ItemEntity]):
	list.resize(get_child_count())
	for i in list.size():
		var child = get_child(i) as ItemContainer
		child.update(list[i])


func _clear_items():
	for child in get_children():
		remove_child(child)
		child.queue_free()


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
