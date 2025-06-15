class_name ActionMethods


static var _instantiate: ActionMethods

static func get_instantiate() -> ActionMethods:
	if not _instantiate:
		_instantiate = ActionMethods.new()
	return _instantiate


#region Properties
func property_add_value(property_name: StringName, property_value: int) -> void:
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(property_name) 
	property.value += property_value
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


func inventory_add_new_items(item_name: StringName, amount: int, _inventory: StringName) -> ItemEntity:
	var inventory = Locator.get_service(_INVENTORY[_inventory])
	return inventory.add_item(item_name, amount)


func inventory_add_used_item(item_name: StringName, used_array: Array[int], _inventory: StringName) -> ItemEntity:
	var inventory = Locator.get_service(_INVENTORY[_inventory])
	var item_data: ItemResource = ResourceCollector.find(ResourceCollector.Collection.ITEMS, item_name)
	return inventory.add_item(item_data, 0, used_array)


func inventories_remove_item(item_name: String, amount: int):
	return Locator.get_service(SummedInventory).remove_item(item_name, amount)


func inventories_has_item(item_name: String, amount: int):
	return Locator.get_service(SummedInventory).has_item(item_name, amount)


#endregion


#region Time
func time_is_used(game_time:int, for_real_time: float, with_progress_screen: bool):
	var _state = Locator.get_service(GameTimeState)
	_state.timeskip(game_time, for_real_time, with_progress_screen)
	await _state.finished_skip
	return _state._remiang_value <= 0


func time_use(game_time: int, for_real_time: float = 1.0, with_progress_screen := false):
	var _state = Locator.get_service(GameTimeState)
	_state.timeskip(game_time, for_real_time, with_progress_screen)
#endregion



#region Events
func event_start(event_name: String):
	var event: EventResource = ResourceCollector.find(ResourceCollector.Collection.EVENTS, event_name)
	Locator.get_service(EventState).start_event(event.instantiate())


func event_start_from_list(eventpack_name: String):
	var list: EventList = ResourceCollector.find(ResourceCollector.Collection.EVENTS_LIST, eventpack_name)
	var event: EventResource = list.get_event()
	Locator.get_service(EventState).start_event(event.instantiate())


#endregion


#region Combat
func start_battle(enemies: PackedStringArray, weapons: Array = []):
	Locator.get_service(GameState).open_battle_screen(",".join(enemies), weapons)


func is_win_in_last_battle() -> bool:
	return Locator.get_service(GameState).is_win_last_battle

#endregion
