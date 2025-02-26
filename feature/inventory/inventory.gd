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
	
	var database := Injector.inject(ResourceDb, self) as ResourceDb
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	var effect = func(item: String, amount: int):
		state = Injector.inject(InventoryLocationState, self) as InventoryLocationState
		var item_data: ItemResource = database.connection.fetch_data("items", StringName(item))
		if not state.has_item(item_data):
			state = Injector.inject(InventoryCharacterState, self) as InventoryCharacterState
		return state.remove_item(item_data, abs(amount))
	
	var ids = database.connection.get_data_string_ids("items")
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "remove item", effect,
		["enum/String/%s" % [",".join(ids)], "int"], 
		["", 1],
	)
	


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
