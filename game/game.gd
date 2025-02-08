extends Node2D

var _state: GameState
var _resource_db: ResourceDb


func _enter_tree() -> void:
	_state = Injector.provide(GameState, GameState.new(), self)
	_resource_db = Injector.provide(ResourceDb,  ResourceDb.new(), self)
	Injector.provide(InventoryRepository, InventoryRepository.new(), self)
	
	_resource_db.db_connect("res://resources/database.gddb")

func _ready() -> void:
	_state.current_screen_changed.connect(Callable(self, "_on_screen_changed"))

	# called when all scenes ready
	Callable(func():
		var game_path = "res://databases/test_editor.sqlite3"
		var save_path = "res://!saves/test_save.db"

		# Создаем character props если их нет в сохранении
		var _save_db = SaveDb.new()
		_save_db.db_connect(save_path)
		var _character_property_repository = CharacterPropertyRepository.new()
		_character_property_repository.init(_resource_db, _save_db)
		_character_property_repository.create_initial_props()
		
		_state.open_world_screen(game_path, save_path)
	).call_deferred()


func _on_screen_changed(prev_screen: Node, current_screen: Node):
	if get_child_count() != 0:
		remove_child(prev_screen)
	add_child(current_screen)
