class_name ScreenMouseEventsState
 

class MouseButton:
	pass

class InitialPress extends MouseButton:
	var local_mouse_pos: Vector2
	var global_mouse_pos: Vector2
	var input_event: InputEventMouseButton

class Click extends MouseButton:
	var input_event: InputEventMouseButton
	var initial_press: InitialPress
	var local_mouse_pos: Vector2
	var global_mouse_pos: Vector2

class DragStart extends MouseButton:
	var input_event: InputEventMouseMotion
	var initial_press: InitialPress 
	var local_mouse_pos: Vector2
	var global_mouse_pos: Vector2

class DragMove extends MouseButton:
	var input_event: InputEventMouseMotion
	var initial_press: InitialPress
	var local_mouse_pos: Vector2
	var global_mouse_pos: Vector2

class DragEnd extends MouseButton:
	var input_event: InputEventMouseButton
	var initial_press: InitialPress
	var local_mouse_pos: Vector2
	var global_mouse_pos: Vector2

class Canceled extends MouseButton:
	var input_event: InputEventMouseButton
	var initial_press: InitialPress
	var local_mouse_pos: Vector2
	var global_mouse_pos: Vector2

var _left_button: Variant = null
signal left_button_changed(value: Variant)
var left_button: Variant:
	get: return _left_button
	set(value):
		if value != _left_button:
			_left_button = value
			left_button_changed.emit(value)

var _right_button: Variant = null
signal right_button_changed(value: Variant)
var right_button: Variant:
	get: return _right_button
	set(value):
		if value != _right_button:
			_right_button = value
			right_button_changed.emit(value)

class Zoom:
	var delta: float

var _zoom: Zoom
signal zoom_changed(value: Zoom)
var zoom: Zoom:
	get: return _zoom
	set(value):
		_zoom = value
		zoom_changed.emit(value)
