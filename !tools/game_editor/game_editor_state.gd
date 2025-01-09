class_name GameEditorState
extends Injectable

signal current_screen_changed(prev_screen: Node, current_screen: Node)
var current_screen: Node:
	set(value):
		var prev_screen = current_screen
		current_screen = value
		current_screen_changed.emit(prev_screen, current_screen)

func open_menu_screen():
	var packed_screen: PackedScene = load("res://game_editor/screens/menu_screen/game_editor__menu_screen.tscn")
	var screen: GameEditor__MenuScreen = packed_screen.instantiate()
	
	# menu screen has no state so that just apply it
	current_screen = screen

func open_editor_screen(game_db_path: String):
	var packed_screen: PackedScene = load("res://game_editor/screens/editor_screen/game_editor__editor_screen.tscn")
	var screen: GameEditor__EditorScreen = packed_screen.instantiate()
	
	screen.data_base_path = game_db_path
	
	current_screen = screen
