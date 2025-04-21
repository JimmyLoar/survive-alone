extends TabBar

@onready var _game_editor_state: GameEditor__EditorScreenState = Locator.get_service(GameEditor__EditorScreenState, self)


func _on_tab_changed(tab: int) -> void:
	var toolEditor: GameEditor__EditorScreenState.ToolType = tab
	_game_editor_state.currentToolEditor = toolEditor
