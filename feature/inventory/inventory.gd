class_name InventoryDisplay
extends MarginContainer

signal item_pressed(item: ItemEntity)
signal double_pressed(item: ItemEntity)

@export var page_size := Vector2i(3, 3)

var state: InventoryState

@onready var items_grid: ItemsGrid = $VBoxContainer/ItemsGrid
@onready var page_controller: PageController = $VBoxContainer/PageController


func _ready() -> void:
	items_grid.item_pressed.connect(_on_items_grid_item_pressed)
	items_grid.duble_pressed.connect(_on_items_grid_duble_pressed)
	items_grid.reset_items_slots(page_size)
	page_controller.set_page_size(page_size.x * page_size.y)


func update(entity: InventoryEntity):
	if not visible or not entity:
		return
	if items_grid:
		var _items := entity.items.duplicate()
		items_grid.update_items_list(_items)

	if page_controller:
		page_controller.set_inventory_size(entity.items.size())
	return


func get_last_pressed():
	return items_grid.button_group.get_pressed_button().get_index()


func _on_items_grid_item_pressed(item_index: int) -> void:
	item_pressed.emit(state.get_item(item_index))


func _on_items_grid_duble_pressed(item_index: int) -> void:
	double_pressed.emit(state.get_item(item_index))
