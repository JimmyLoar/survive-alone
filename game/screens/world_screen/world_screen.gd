class_name WorldScreen
extends Node2D

@export var game_db_path: String
@export var save_db_path: String



func _enter_tree() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	var save_db = Locator.get_service(SaveDb)
	save_db.db_connect(save_db_path)

	Locator.initialize_service(InventoryRepository, [save_db])
	Locator.initialize_service(BiomeRepository)
	Locator.initialize_service(BiomeRectRepository)
	Locator.initialize_service(WorldObjectRepository)
	Locator.initialize_service(WorldScreenState)
	Locator.initialize_service(CharacterRepository, [save_db])
	
	Locator.get_service(GameDb).db_connect(game_db_path)


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	if type != "world":
		return
	
	var result = false
	match key:
		"structure_change": 
			var location = Locator.get_service(CharacterLocationState)
			if not location.current_location_changed.is_connected(_on_changed_location.bind(requester, value.split("/"))):
				location.current_location_changed.connect(_on_changed_location.bind(requester, value.split("/")))
	
	requester.set_completed(result)


func _on_changed_location(new_location, requester: QuestCondition, value: Array):
	requester.set_completed(true)
	Locator.get_service(CharacterLocationState).current_location_changed.disconnect(_on_changed_location.bind(requester, value))
	Locator.get_service(CharacterState).stop_moving()
	ActionMethods.new().callv(value[0], value.slice(1))
