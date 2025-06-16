extends Node2D

var _state: GameState


func _enter_tree() -> void:
	_state = Locator.get_service(GameState)


func _ready() -> void:
	_state.current_screen_changed.connect(Callable(self, "_on_screen_changed"))

	# called when all scenes ready
	Callable(func():
		var game_path = ProjectSettings.get_setting("databases/game_database_path")
		var save_path = ProjectSettings.get_setting("databases/save_database_path")
		
		_ensure_user_directory_exists(save_path)
		_create_new_save_if_not_exist(save_path)
		
		_state.open_world_screen(game_path, save_path)
	).call_deferred()

func _ensure_user_directory_exists(path: String) -> void:
	var absolute_path = ProjectSettings.globalize_path(path)
	var parts = absolute_path.split("/")
	
	var current_path := ""
	for part in parts:
		if part != parts[-1]:
			if part == "":
				continue

			current_path += part + "/"
			if DirAccess.dir_exists_absolute(current_path):
				continue
			
			var error = DirAccess.make_dir_absolute(current_path)
			assert(error == OK, "Не удалось создать директорию: %s (ошибка: %s)" % [current_path, error_string(error)])

func _on_screen_changed(prev_screen: Node, current_screen: Node):
	if get_child_count() != 0:
		remove_child(prev_screen)
	add_child(current_screen)
	
func _create_new_save_if_not_exist(save_path: String):
	if FileAccess.file_exists(save_path):
		_state.is_new_game = false
		return
	
	var save_db = SaveDb.new()
	var character_property_repository = CharacterPropertyRepository.new()
	var character_repository = CharacterRepository.new(save_db)
	var inventory_repository = InventoryRepository.new(save_db)

	save_db.db_connect(save_path)
	character_property_repository.init(save_db)
	
	
	var character_props_data = ResourceCollector.find_all(ResourceCollector.Collection.CHARACTER_PROPERTY)
	var character_props = character_props_data.map(func(data): return CharacterPropertyEntity.new(data))
	var character_world_pos = Vector2(0, 0)
	var character_inventory = InventoryEntity.new(
		InventoryRepository.PLAYER_ID,
		InventoryEntity.BelongsAtObject.new(-1, InventoryEntity.BelongsAtObject.Type.PLAYER),
		[
			ItemEntity.new(
				ResourceCollector.uid(ResourceCollector.Items, "food_canned_food"),
				5,
			),
			ItemEntity.new(
				ResourceCollector.uid(ResourceCollector.Items, "food_water_clear"),
				30,
			),
			ItemEntity.new(
				ResourceCollector.uid(ResourceCollector.Items, "resource_wood"),
				10,
			),
			ItemEntity.new(
				ResourceCollector.uid(ResourceCollector.Items, "food_fresh_meat"),
				5,
			),
		]
	)
	
	character_repository.insert_world_position(character_world_pos)
	character_property_repository.create_batch(character_props)
	inventory_repository.create(character_inventory)
	
