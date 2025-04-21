extends Node2D

var _state: GameEditorState

func _enter_tree() -> void:
	_state = Locator.initialize_service(GameEditorState, GameEditorState.new())

func _ready() -> void:
	_state.current_screen_changed.connect(Callable(self, "_on_screen_changed"))

	# called when all scenes ready
	Callable(func():
		_state.open_menu_screen()
	).call_deferred()


func _on_screen_changed(prev_screen: Node, current_screen: Node):
	if get_child_count() != 0:
		remove_child(prev_screen)
	add_child(current_screen)
