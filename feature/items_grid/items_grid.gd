class_name ItemsGrid
extends GridContainer

signal item_selected(index: int)


@export var button_group := ButtonGroup.new()
var timer: SceneTreeTimer
var _entity: InventoryEntity

@onready var logger = Log.get_global_logger().with('ItemGrid')


func _init() -> void:
	set("theme_override_constants/h_separation", 0)
	set("theme_override_constants/v_separation", 0)
	button_group.allow_unpress = true


func initialize_items(_columns: int, raws: int):
	columns = _columns
	for i in columns * raws:
		var new_item := ItemContainer.new()
		#new_item.pressed.connect(_on_item_pressed.bind(i))
		new_item.button_group = button_group
		new_item.toggle_mode = true
		new_item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_item.size_flags_vertical = Control.SIZE_EXPAND_FILL
		add_child(new_item)
		new_item.pressed.connect.call_deferred(_on_item_pressed.bind(new_item.get_index()))


func _on_item_pressed(index: int):
	# Проверяем, есть ли предмет в этом слоте
	if index < _entity.items.size() and _entity.items[index] and not _entity.items[index].is_empty():
		item_selected.emit(index)
	else:
		# Передаем null для пустого слота
		item_selected.emit(-1)


func set_entity(entity: InventoryEntity):
	_entity = entity


func display_items(items: Array[ItemEntity]):
	var i = 0
	for item: ItemEntity in items:
		var container = get_child(i) as ItemContainer
		container.update(items[i])
		i += 1
	
	# Обрабатываем пустые слоты
	for j in range(i, get_child_count()):
		var container = get_child(j) as ItemContainer
		container.update(null)
