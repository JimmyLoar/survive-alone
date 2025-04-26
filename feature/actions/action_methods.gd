class_name ActionMethods


static var _instantiate: ActionMethods

static func get_instantiate() -> ActionMethods:
	if not _instantiate:
		_instantiate = ActionMethods.new()
	return _instantiate


#region Properties
func property_add_value(name: StringName, value: int) -> void:
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(name) 
	property.value += value
	state.set_property(property)


func property_greater_than_value(prop_name: String, check_value: int) -> bool: 
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(prop_name) as CharacterPropertyEntity
	return property.value >= check_value


func property_less_than_max (prop_name: String) -> bool: 
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(prop_name) as CharacterPropertyEntity
	return property.value < property.get_max_value()


#endregion






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
