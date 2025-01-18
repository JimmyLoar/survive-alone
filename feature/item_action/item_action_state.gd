class_name ItemActionState
extends Node




func can_execute(action_entity: ItemActionEntity) -> bool:
	return true


func execute(action_entity: ItemActionEntity) -> void:
	var data := action_entity.get_values()
	if data.has(&"properties"):
		_execute_properties(data.properties)


func _execute_properties(properties: Dictionary):
	var property_repository: CharacterPropertyRepository = _take_properties_repository()
	var prop_state := Injector.inject(CharacterState, self) as CharacterState
	for property_name in properties:
		if properties[property_name] == 0:
			continue
		
		var property: CharacterPropertyResource = property_repository.get_by_string_id(property_name)
		property.default_value += properties[property_name]
		prop_state.set_property(property)
		


func _take_properties_repository() -> CharacterPropertyRepository:
	return Injector.inject(CharacterPropertyRepository, self)
