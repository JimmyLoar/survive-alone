extends Node2D

var _state: GameState

func _enter_tree() -> void:
	_state = Injector.provide(GameState, GameState.new(), self)
	var resource_db = Injector.provide(ResourceDb,  ResourceDb.new(), self)
	Injector.provide(CharacterPropertyRepository, CharacterPropertyRepository.new(self), self)
	Injector.provide(InventoryRepository, InventoryRepository.new(), self)
	
	resource_db.db_connect("res://resources/database.gddb")

func _ready() -> void:
	_state.current_screen_changed.connect(Callable(self, "_on_screen_changed"))

	# called when all scenes ready
	Callable(func():
		_state.open_world_screen("res://databases/test_editor.sqlite3", "res://!saves/test_save.db")
	).call_deferred()


func _on_screen_changed(prev_screen: Node, current_screen: Node):
	if get_child_count() != 0:
		remove_child(prev_screen)
	add_child(current_screen)
