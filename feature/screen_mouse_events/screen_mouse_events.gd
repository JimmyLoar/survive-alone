class_name ScreenMouseEvents
extends Control

@export var zoom_factor: float = 0.1
@export var zoom_sensitivity = 30
@export var drag_threshold: float = 5 

var _state: ScreenMouseEventsState


func _enter_tree() -> void:
	_state = Injector.provide(ScreenMouseEventsState, ScreenMouseEventsState.new(), self, Injector.ContainerType.CLOSEST)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_process_left_button(event)
		_process_right_button(event)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_process_left_button(event)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_process_right_button(event)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_process_zoom(event)
	elif event is InputEventPanGesture:
		_process_zoom(event)


func _process_left_button(event: InputEvent):
	# drag or click start
	if _state.left_button == null and event is InputEventMouseButton and event.is_pressed():
		var new_left_button = ScreenMouseEventsState.InitialPress.new()
		new_left_button.input_event = event
		new_left_button.local_mouse_pos = get_local_mouse_position()
		new_left_button.global_mouse_pos = get_global_mouse_position()
		_state.left_button = new_left_button

	# button up and it is not yet drag so that it is click
	elif event is InputEventMouseButton and event.is_released() and  _state.left_button  is ScreenMouseEventsState.InitialPress:
		var new_left_button = ScreenMouseEventsState.Click.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button
		new_left_button.local_mouse_pos = get_local_mouse_position()
		new_left_button.global_mouse_pos = get_global_mouse_position()
		_state.left_button = new_left_button

	# check threshold and start drag
	elif event is InputEventMouseMotion and _state.left_button  is ScreenMouseEventsState.InitialPress:
		var local_mouse_pos = get_local_mouse_position()
		if local_mouse_pos.distance_to(_state.left_button.local_mouse_pos) > drag_threshold:
			var new_left_button = ScreenMouseEventsState.DragStart.new()
			new_left_button.input_event = event
			new_left_button.initial_press = _state.left_button
			new_left_button.local_mouse_pos = get_local_mouse_position()
			new_left_button.global_mouse_pos = get_global_mouse_position()
			_state.left_button = new_left_button

	# is drag move
	elif event is InputEventMouseMotion and (_state.left_button is ScreenMouseEventsState.DragMove or _state.left_button  is ScreenMouseEventsState.DragStart):
		var new_left_button = ScreenMouseEventsState.DragMove.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button.initial_press
		new_left_button.local_mouse_pos = get_local_mouse_position()
		new_left_button.global_mouse_pos = get_global_mouse_position()
		_state.left_button = new_left_button

	# is drag end
	elif event is InputEventMouseButton and event.is_released() and  (_state.left_button is ScreenMouseEventsState.DragMove or _state.left_button  is ScreenMouseEventsState.DragStart):
		var new_left_button = ScreenMouseEventsState.DragEnd.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button.initial_press
		new_left_button.local_mouse_pos = get_local_mouse_position()
		new_left_button.global_mouse_pos = get_global_mouse_position()
		_state.left_button = new_left_button

	elif event.is_canceled():
		var new_left_button = ScreenMouseEventsState.Canceled.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button.initial_press
		new_left_button.local_mouse_pos = get_local_mouse_position()
		new_left_button.global_mouse_pos = get_global_mouse_position()
		_state.left_button = new_left_button

	elif  _state.left_button is ScreenMouseEventsState.DragEnd or _state.left_button is ScreenMouseEventsState.Click or _state.left_button is ScreenMouseEventsState.Canceled:
		_state.left_button = null

func _process_right_button(event: InputEvent):
	# drag or click start
	if _state.right_button == null and event is InputEventMouseButton and event.is_pressed():
		var new_right_button = ScreenMouseEventsState.InitialPress.new()
		new_right_button.input_event = event
		new_right_button.local_mouse_pos = get_local_mouse_position()
		new_right_button.global_mouse_pos = get_global_mouse_position()
		_state.right_button = new_right_button

	# button up and it is not yet drag so that it is click
	elif event is InputEventMouseButton and event.is_released() and  _state.right_button  is ScreenMouseEventsState.InitialPress:
		var new_right_button = ScreenMouseEventsState.Click.new()
		new_right_button.input_event = event
		new_right_button.initial_press = _state.right_button
		new_right_button.local_mouse_pos = get_local_mouse_position()
		new_right_button.global_mouse_pos = get_global_mouse_position()
		_state.right_button = new_right_button

	# check threshold and start drag
	elif event is InputEventMouseMotion and _state.right_button  is ScreenMouseEventsState.InitialPress:
		var local_mouse_pos = get_local_mouse_position()
		if local_mouse_pos.distance_to(_state.right_button.local_mouse_pos) > drag_threshold:
			var new_right_button = ScreenMouseEventsState.DragStart.new()
			new_right_button.input_event = event
			new_right_button.initial_press = _state.right_button
			new_right_button.local_mouse_pos = get_local_mouse_position()
			new_right_button.global_mouse_pos = get_global_mouse_position()
			_state.right_button = new_right_button

	# is drag move
	elif event is InputEventMouseMotion and (_state.right_button is ScreenMouseEventsState.DragMove or _state.right_button  is ScreenMouseEventsState.DragStart):
		var new_right_button = ScreenMouseEventsState.DragMove.new()
		new_right_button.input_event = event
		new_right_button.initial_press = _state.right_button.initial_press
		new_right_button.global_mouse_pos = get_local_mouse_position()
		new_right_button.local_mouse_pos = get_global_mouse_position()
		_state.right_button = new_right_button

	# is drag end
	elif event is InputEventMouseButton and event.is_released() and  (_state.right_button is ScreenMouseEventsState.DragMove or _state.right_button  is ScreenMouseEventsState.DragStart):
		var new_right_button = ScreenMouseEventsState.DragEnd.new()
		new_right_button.input_event = event
		new_right_button.initial_press = _state.right_button.initial_press
		new_right_button.local_mouse_pos = get_local_mouse_position()
		new_right_button.global_mouse_pos = get_global_mouse_position()
		_state.right_button = new_right_button

	elif event.is_canceled():
		var new_right_button = ScreenMouseEventsState.Canceled.new()
		new_right_button.input_event = event
		new_right_button.initial_press = _state.right_button.initial_press
		new_right_button.local_mouse_pos = get_local_mouse_position()
		new_right_button.global_mouse_pos = get_global_mouse_position()
		_state.right_button = new_right_button

	elif  _state.right_button is ScreenMouseEventsState.DragEnd or _state.right_button is ScreenMouseEventsState.Click or _state.right_button is ScreenMouseEventsState.Canceled:
		_state.right_button = null

func _process_zoom(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var new_zoom = _state.Zoom.new()
			new_zoom.delta = zoom_factor
			_state.zoom = new_zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = _state.Zoom.new()
			new_zoom.delta = -zoom_factor
			_state.zoom = new_zoom
	elif event is InputEventPanGesture:
		var new_zoom = _state.Zoom.new()
		new_zoom.delta = event.delta.y
		_state.zoom = new_zoom
