class_name GameState
extends Node2D


signal started_changing_screen
signal screen_loaded
signal current_screen_changed(prev_screen: Node, current_screen: Node)
var current_screen: Node:
	set(value):
		var prev_screen = current_screen
		current_screen = value
		_on_screen_changed(prev_screen, current_screen)

var is_new_game := true
var is_win_last_battle := false

var _cache := {}
var _loading: String

@onready var _loading_screen: CanvasLayer = $LoadingLayer


func _enter_tree() -> void:
	Locator.add_initialized_service(self)
	set_process(false)


func _ready() -> void:
	# called when all scenes ready
	Callable(func():
		var game_path = ProjectSettings.get_setting("databases/game_database_path")
		var save_path = ProjectSettings.get_setting("databases/save_database_path")
		
		_ensure_user_directory_exists(save_path)
		_create_new_save_if_not_exist(save_path)
		
		open_world_screen(game_path, save_path)
	).call_deferred()


func _process(delta: float) -> void:
	if ResourceLoader.load_threaded_get_status(_loading) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		set_process(false)
		screen_loaded.emit()


func open_world_screen(game_db_path: String, save_db_path: String):
	if _loading: breakpoint
	var screen: WorldScreen
	if not _cache.has("world"):
		await _load_screen("uid://bsq170wia7k5p")
		var packed_screen: PackedScene = ResourceLoader.load_threaded_get("uid://bsq170wia7k5p")
		screen = packed_screen.instantiate()
		screen.game_db_path = game_db_path
		screen.save_db_path = save_db_path
		_cache["world"] = screen
	
	else:
		screen = _cache["world"]
	
	current_screen = screen


func open_battle_screen(enemies: String, weapons: Array):
	if _loading: breakpoint
	var screen: BattleScreen
	if not _cache.has("battle"):
		await _load_screen("uid://b473wtxpubu8w")
		var packed: PackedScene = ResourceLoader.load_threaded_get("uid://b473wtxpubu8w")
		screen = packed.instantiate()
		_cache["battle"] = screen
	
	else:
		screen = _cache["battle"]
	
	screen.set_enemies(enemies)
	screen.set_weapons(weapons)
	current_screen = screen


func _load_screen(path: String):
	self.set_process(true)
	self._loading = path
	ResourceLoader.load_threaded_request(_loading)
	self._open_loading_screen()
	await screen_loaded
	self._close_loading_screen()


func _open_loading_screen():
	_loading_screen.show()


func _close_loading_screen():
	_loading_screen.hide()
	_loading = ""


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
		is_new_game = false
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
	
