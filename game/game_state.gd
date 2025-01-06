class_name GameState
extends Injectable

signal current_screen_changed(prev_screen: Node, current_screen: Node)
var current_screen: Node:
	set(value):
		var prev_screen = current_screen
		current_screen = value
		current_screen_changed.emit(prev_screen, current_screen)

func open_world_screen(game_db_path: String):
	var packed_screen: PackedScene = load("res://game/screens/world_screen/world_screen.tscn")
	var screen: WorldScreen = packed_screen.instantiate()
	
	screen.data_base_path = game_db_path
	
	current_screen = screen
