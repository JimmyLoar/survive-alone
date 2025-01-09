class_name GameEditor__EditorScreenState
extends Injectable

enum ToolType {
	Biome = 0,
	Structure = 1
}

signal currentToolChanged(value: ToolType)
var _currentTool: ToolType = ToolType.Biome
var currentTool: ToolType:
	get:
		return _currentTool
	set(value):
		_currentTool = value
		currentToolChanged.emit(value)
