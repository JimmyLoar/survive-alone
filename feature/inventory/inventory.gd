class_name InventoryDisplay
extends MarginContainer

signal item_pressed(item: ItemEntity)
signal duble_pressed(item: ItemEntity)

@export var page_size := Vector2i(3, 3)

@onready var items_grid: SlotCotroller = $VBoxContainer/ItemsGrid
@onready var page_controller: PageController = $VBoxContainer/PageController

var _inventory_entity: InventoryEntity

var inventory: InventoryState: 
	set = set_inventory


func _ready() -> void:
	items_grid.init_items(page_size)
	page_controller.set_page_size(page_size.x * page_size.y)


func set_inventory(new_inventory: InventoryState):
	if inventory and inventory.changed_inventory_entity.is_connected(update):
		inventory.changed_inventory_entity.disconnect(update)
	
	inventory = new_inventory
	if not inventory.changed_inventory_entity.is_connected(update):
		inventory.changed_inventory_entity.connect(update)
	
	update(_inventory_entity)


func update(entity: InventoryEntity):
	if not visible or not entity: return
	if items_grid:
		var _items := entity.items.duplicate()
		items_grid.update_items_list(_items)
	
	if page_controller:
		page_controller.set_inventory_size(inventory.get_size())
	return


func get_last_pressed():
	return items_grid.button_group.get_pressed_button().get_index()


func _on_item_controller_item_pressed(item_index: int) -> void:
	item_pressed.emit(inventory.get_item(item_index))


func _on_item_controller_duble_pressed(item_index: int) -> void:
	duble_pressed.emit(inventory.get_item(item_index))
