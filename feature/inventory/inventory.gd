class_name InventoryDisplay
extends MarginContainer


signal item_pressed(item: ItemEntity)
signal double_pressed(item: ItemEntity)

@export var page_size := Vector2i(3, 3)

var state: InventoryState

@onready var items_grid: ItemsGrid = $VBoxContainer/ItemsGrid
@onready var page_controller: PageController = $VBoxContainer/PageController


func _ready() -> void:
	_register_methods()
	items_grid.item_pressed.connect(_on_items_grid_item_pressed)
	items_grid.duble_pressed.connect(_on_items_grid_duble_pressed)
	items_grid.reset_items_slots(page_size)
	page_controller.set_page_size(page_size.x * page_size.y)


func _register_methods():
	var database := Injector.inject(ResourceDb, self) as ResourceDb
	var location_state  := Injector.inject(InventoryLocationState, self) as InventoryLocationState
	var character_state := Injector.inject(InventoryCharacterState, self) as InventoryCharacterState
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	var items_id = database.connection.get_data_string_ids("items")
	
	var get_item_amount = func (inventory: InventoryState, item_name: String) -> int:
		var item = inventory.fetch_item(item_name)
		if not item:
			return 0
		return item.get_total_amount()
		
	var get_item_durability = func (inventory: InventoryState, item_name: String) -> int:
		var item = inventory.fetch_item(item_name)
		if not item:
			return 0
		return item.get_total_dutability()
	
	var remove_item = func(item_name: String, amount: int):
		var remove_amount = min(get_item_amount.call(character_state, item_name), amount)
		remove_amount = character_state.remove_item(item_name, remove_amount)
		remove_amount = location_state.remove_item(item_name, remove_amount)
		return remove_amount
	
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "remove item", remove_item,
		["enum/String/%s" % [",".join(items_id)], "int"], 
		["item_name", "quantity"],
		["", 1],
	)
	
	var add_item = func(item: StringName, amount: int, inventory: InventoryState) -> ItemEntity:
		var item_data: ItemResource = database.connection.fetch_data("items", item)
		return inventory.add_item(item_data, amount)
	
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "add new item in character", 
		add_item.bind(character_state),
		["enum/String/%s" % [",".join(items_id)], "int"], 
		["item_name", "quantity"],
		["", 1],
	)
	
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "add new item in location", 
		add_item.bind(location_state),
		["enum/String/%s" % [",".join(items_id)], "int"], 
		["item_name", "quantity"],
		["", 1],
	)
	
	var add_used_items = func(item: StringName, used: Array[int], inventory: InventoryState):
		var item_data: ItemResource = database.connection.fetch_data("items", item)
		return inventory.add_item(item_data, 0, used)
	
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "add used item in character", 
		add_used_items.bind(character_state),
		["enum/String/%s" % [",".join(items_id)], "Array/int"], 
		["item_name", "durabilities"],
		["", [50]],
	)
	
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "add used item in location", 
		add_used_items.bind(location_state),
		["enum/String/%s" % [",".join(items_id)], "Array/int"], 
		["item_name", "durabilities"],
		["", [50]],
	)
	
	var has_amount = func(item_name: String, amount: int):
		var total: int = 0
		total += get_item_amount.call(character_state, item_name)
		total += get_item_amount.call(location_state, item_name)
		return total >= amount
	
	execute_keeper.register(
		execute_keeper.TYPE_CONDITION, "has item total amount", has_amount,
		["enum/String/%s" % [",".join(items_id)], "int"], 
		["item_name", "quantity"],
		["", 1],
	)
	
	var has_durability = func(item_name: String, amount: int):
		var total: int = 0
		total += get_item_durability.call(character_state, item_name)
		total += get_item_durability.call(location_state, item_name)
		return total >= amount
	
	execute_keeper.register(
		execute_keeper.TYPE_CONDITION, "has item durability", has_durability,
		["enum/String/%s" % [",".join(items_id)], "int"], 
		["item_name", "durability"],
		["", 1],
	)
	return


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
