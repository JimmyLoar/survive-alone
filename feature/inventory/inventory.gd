class_name InventoryDisplay
extends MarginContainer

signal item_pressed(item: Item)
signal duble_pressed(item: Item)

@export var page_size := Vector2i(3, 3)

@onready var items_grid: SlotCotroller = $VBoxContainer/ItemsGrid
@onready var page_controller: PageController = $VBoxContainer/PageController

var _items: Array[Item]

var inventory: InventoryState: 
	set = set_inventory


func _ready() -> void:
	visibility_changed.connect(update)
	items_grid.init_items(page_size)
	page_controller.set_page_size(page_size.x * page_size.y)


func set_inventory(new_inventory: InventoryState):
	if inventory and inventory.changed.is_connected(update):
		inventory.changed.disconnect(update)
	
	inventory = new_inventory
	if not inventory.changed.is_connected(update):
		inventory.changed.connect(update)
	
	update()


func update():
	if not visible or not inventory: return
	if items_grid:
		_items = inventory.get_items(true)
		items_grid.update_items(_items)
	
	if page_controller:
		page_controller.set_inventory_size(inventory.get_size())
	return


func get_last_pressed():
	return items_grid.button_group.get_pressed_button().get_index()


func _on_item_controller_item_pressed(item_index: int) -> void:
	item_pressed.emit(_items[item_index])


func _on_item_controller_duble_pressed(item_index: int) -> void:
	duble_pressed.emit(_items[item_index])
