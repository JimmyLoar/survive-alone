class_name ActionMethods


#region Properties
func add_property_value(name: StringName, value: int) -> void:
	var state = Locator.get_service(CharacterState) as CharacterState
	var property := state.get_property(name) 
	property.value += value
	state.set_property(property)




#endregion
#region Events
func start_event(event_name: String):
	var db_resource = Locator.get_service(GameDb)
	var event: EventResource = db_resource.connection.fetch_data("event", StringName(event_name))
	Locator.get_service(EventState).activate_event(event)


func start_event_from_list(list_name: String):
	var db_resource = Locator.get_service(GameDb)
	var list: EventList = db_resource.connection.fetch_data("event_list", StringName(list_name))
	var event: EventResource = list.get_event()
	Locator.get_service(EventState).activate_event(event)


#endregion
