class_name ScreenMouseEventsState
extends Injectable

class InitialPress:
	var mouse_pos: Vector2
	var input_event: InputEventMouseButton

class Click:
	var input_event: InputEventMouseButton
	var initial_press: InitialPress
	var mouse_pos: Vector2

class DragStart:
	var input_event: InputEventMouseMotion
	var initial_press: InitialPress 
	var mouse_pos: Vector2

class DragMove:
	var input_event: InputEventMouseMotion
	var initial_press: InitialPress
	var mouse_pos: Vector2

class DragEnd:
	var input_event: InputEventMouseButton
	var initial_press: InitialPress
	var mouse_pos: Vector2

class Canceled:
	var input_event: InputEventMouseButton
	var initial_press: InitialPress
	var mouse_pos: Vector2

var _left_button: Variant = null
signal left_button_changed(value: Variant)
var left_button: Variant:
	get: return _left_button
	set(value):
		if value != _left_button:
			_left_button = value
			left_button_changed.emit(value)
