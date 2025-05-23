class_name WorldScreen
extends Node2D

@export var game_db_path: String
@export var save_db_path: String



func _enter_tree() -> void:
	var save_db = Locator.get_service(SaveDb)
	save_db.db_connect(save_db_path)

	Locator.initialize_service(InventoryRepository, [save_db])
	Locator.initialize_service(BiomeRepository)
	Locator.initialize_service(BiomeRectRepository)
	Locator.initialize_service(WorldObjectRepository)
	Locator.initialize_service(WorldScreenState)
	Locator.initialize_service(CharacterRepository, [save_db])
	Locator.initialize_service(Scenario)
	
	Locator.get_service(GameDb).db_connect(game_db_path)
