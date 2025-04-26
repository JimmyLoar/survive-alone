class_name ActionMethods


static var _instantiate: ActionMethods

static func get_instantiate() -> ActionMethods:
	if not _instantiate:
		_instantiate = ActionMethods.new()
	return _instantiate


func _init() -> void:
	pass



#region Properties
func property_add_value(property_name: StringName, value: int) -> void:
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(property_name) 
	property.value += value
	state.set_property(property)


func property_greater_than_value(property_name: String, check_value: int) -> bool: 
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(property_name) as CharacterPropertyEntity
	return property.value >= check_value


func property_less_than_max (property_name: String) -> bool: 
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(property_name) as CharacterPropertyEntity
	return property.value < property.get_max_value()


#endregion
#region Inventory
var _INVENTORY = {
	"InventoryCharacterState": InventoryCharacterState,
	"InventoryLocationState": InventoryLocationState,
}


func inventory_add_new_items(item: StringName, amount: int, _inventory: StringName) -> ItemEntity:
	var database = Locator.get_service(GameDb)
	var inventory = Locator.get_service(_INVENTORY[_inventory])
	var item_data: ItemResource = database.connection.fetch_data("items", item)
	return inventory.add_item(item_data, amount)


func inventory_add_used_item(item: StringName, used: Array[int], _inventory: StringName) -> ItemEntity:
	var database = Locator.get_service(GameDb)
	var inventory = Locator.get_service(_INVENTORY[_inventory])
	var item_data: ItemResource = database.connection.fetch_data("items", item)
	return inventory.add_item(item_data, 0, used)


func inventories_remove_item(item: String, value: int):
	return Locator.get_service(SummedInventory).remove_item(item, value)


func inventories_has_item(item: String, value: int):
	return Locator.get_service(SummedInventory).has_item(item, value)


#endregion
func time_is_used(game_time:int, for_real_time: float, with_progress_screen: bool):
	var _state = Locator.get_service(GameTimeState)
	_state.timeskip(game_time, for_real_time, with_progress_screen)
	await _state.finished_skip
	return _state._remiang_value <= 0


func time_use(game_time: int, for_real_time: float = 1.0, with_progress_screen := false):
	var _state = Locator.get_service(GameTimeState)
	_state.timeskip(game_time, for_real_time, with_progress_screen)



#region Events
func event_start(event_name: String):
	var db_resource = Locator.get_service(GameDb)
	var event: EventResource = db_resource.connection.fetch_data("event", StringName(event_name))
	Locator.get_service(EventState).activate_event(event)


func event_start_from_list(list_name: String):
	var db_resource = Locator.get_service(GameDb)
	var list: EventList = db_resource.connection.fetch_data("event_list", StringName(list_name))
	var event: EventResource = list.get_event()
	Locator.get_service(EventState).activate_event(event)


#endregion
