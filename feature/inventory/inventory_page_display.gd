class_name InventoryPageDisplay
extends MarginContainer


signal item_pressed(item: ItemEntity)
signal double_pressed(item: ItemEntity)

@export var _page_size := Vector2i(3, 3)


var _entity: InventoryEntity


@onready var _items_grid: ItemsGrid = %ItemsGrid
@onready var _page_controller: PageController = %PageController


func set_entity(new_entity: InventoryEntity):
	if _entity != new_entity:
		_entity = new_entity
		_page_controller.set_entity(new_entity)
		_items_grid.set_entity(new_entity)
	update()


func _ready() -> void:
	_items_grid.initialize_items(_page_size.x, _page_size.y)
	_items_grid.item_selected.connect(_on_item_pressed)
	
	_page_controller.page_size = _page_size.x * _page_size.y
	_page_controller.changed_page.connect(_on_change_page)


func update():
	_page_controller.update_max_page()
	_on_change_page(_page_controller.page)


func _on_change_page(page: int):
	var begin = (page - 1) * _page_controller.page_size
	var end = page * _page_controller.page_size
	var displayed_items = _entity.items.slice(begin, end)
	displayed_items.resize(_page_controller.page_size)
	_items_grid.display_items(displayed_items)


func _on_item_pressed(index: int):
	if index == -1:
		# Клик по пустому слоту
		item_pressed.emit(null)
	else:
		index = index + _page_controller.page_size * (_page_controller.page - 1)
		if index >= 0 and index < _entity.items.size():
			item_pressed.emit(_entity.items[index])
		else:
			item_pressed.emit(null)
