class_name GameState
 

signal current_screen_changed(prev_screen: Node, current_screen: Node)
var current_screen: Node:
	set(value):
		var prev_screen = current_screen
		current_screen = value
		current_screen_changed.emit(prev_screen, current_screen)

var is_new_game := true
var is_win_last_battle := false

var _cache := {}

func open_world_screen(game_db_path: String, save_db_path: String):
	var screen: WorldScreen
	if not _cache.has("world"):
		var packed_screen: PackedScene = load("uid://bsq170wia7k5p")
		screen = packed_screen.instantiate()
		screen.game_db_path = game_db_path
		screen.save_db_path = save_db_path
		_cache["world"] = screen
	
	else:
		screen = _cache["world"]
	
	current_screen = screen


func open_battle_screen(enemies: String, weapons: Array):
	var screen: BattleScreen
	if not _cache.has("battle"):
		var packed: PackedScene = load("uid://b473wtxpubu8w")
		screen = packed.instantiate()
		_cache["battle"] = screen
	
	else:
		screen = _cache["battle"]
	
	screen.set_enemies(enemies)
	screen.set_weapons(weapons)
	current_screen = screen
