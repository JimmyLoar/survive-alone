class_name ScreenMouseEvents
extends Control

@export var drag_threshold: float = 5 
var _state: ScreenMouseEventsState

func _enter_tree() -> void:
	_state = Injector.provide(ScreenMouseEventsState, ScreenMouseEventsState.new(), self, "closest")

func _input(event: InputEvent) -> void:
	# drag or click start
	if _state.left_button == null and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var new_left_button = ScreenMouseEventsState.InitialPress.new()
		new_left_button.input_event = event
		new_left_button.mouse_pos = get_local_mouse_position()
		_state.left_button = new_left_button

	# button up and it is not yet drag so that it is click
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and  _state.left_button  is ScreenMouseEventsState.InitialPress:
		var new_left_button = ScreenMouseEventsState.Click.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button
		new_left_button.mouse_pos = get_local_mouse_position()
		_state.left_button = new_left_button

	# check threshold and start drag
	elif event is InputEventMouseMotion and _state.left_button  is ScreenMouseEventsState.InitialPress:
		var mouse_pos = get_local_mouse_position()
		if mouse_pos.distance_to(_state.left_button.mouse_pos) > drag_threshold:
			var new_left_button = ScreenMouseEventsState.DragStart.new()
			new_left_button.input_event = event
			new_left_button.initial_press = _state.left_button
			new_left_button.mouse_pos = get_local_mouse_position()
			_state.left_button = new_left_button

	# is drag move
	elif event is InputEventMouseMotion and (_state.left_button is ScreenMouseEventsState.DragMove or _state.left_button  is ScreenMouseEventsState.DragStart):
		var new_left_button = ScreenMouseEventsState.DragMove.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button.initial_press
		new_left_button.mouse_pos = get_local_mouse_position()
		_state.left_button = new_left_button

	# is drag end
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and  (_state.left_button is ScreenMouseEventsState.DragMove or _state.left_button  is ScreenMouseEventsState.DragStart):
		var new_left_button = ScreenMouseEventsState.DragEnd.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button.initial_press
		new_left_button.mouse_pos = get_local_mouse_position()
		_state.left_button = new_left_button

	elif event.is_canceled():
		var new_left_button = ScreenMouseEventsState.Canceled.new()
		new_left_button.input_event = event
		new_left_button.initial_press = _state.left_button.initial_press
		new_left_button.mouse_pos = get_local_mouse_position()
		_state.left_button = new_left_button

	elif  _state.left_button is ScreenMouseEventsState.DragEnd or _state.left_button is ScreenMouseEventsState.Click or _state.left_button is ScreenMouseEventsState.Canceled:
		_state.left_button = null
