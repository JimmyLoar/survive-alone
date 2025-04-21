class_name MainCamera
extends Camera2D

@export var max_zoom = 2.0
@export var min_zoom = 0.5

@onready var _screen_mouse_event_state: ScreenMouseEventsState = Locator.get_service(ScreenMouseEventsState)
var _state: MainCameraState


func _ready() -> void:
	_state = Locator.initialize_service(MainCameraState, [self])
	_screen_mouse_event_state.left_button_changed.connect(Callable(self, "_on_screen_left_mouse_button_changed"))
	_screen_mouse_event_state.zoom_changed.connect(Callable(self, "_on_screen_zoom_changed"))
	_state.mode_changed.connect(Callable(self, "mode_changed"))
	# called when all scenes ready
	Callable(func():
		_update_state_viewport_rect()
	).call_deferred()


func _on_screen_left_mouse_button_changed(value):
	if value is ScreenMouseEventsState.DragStart or value is ScreenMouseEventsState.DragMove or value is ScreenMouseEventsState.DragEnd:
		if value is ScreenMouseEventsState.DragStart:
			_state.mode = MainCameraState.FreeMode.new()
			_state.mode.initial_pos = position
		var pos_shift = value.initial_press.local_mouse_pos - value.local_mouse_pos
		position = _state.mode.initial_pos + pos_shift / zoom
		_update_state_viewport_rect()

func _on_screen_zoom_changed(value: ScreenMouseEventsState.Zoom):
	zoom_camera(value.delta)


func zoom_camera(factor:float) -> void:
	# зуум с ограничениями
	var zoom_delta = Vector2(factor, factor)
	var new_zoom = clamp(
		zoom + zoom_delta,
		 Vector2(min_zoom, min_zoom),
		 Vector2(max_zoom, max_zoom)
		)

	if new_zoom == zoom:
		return
	zoom = new_zoom

	_update_state_viewport_rect()


func _update_state_viewport_rect():
	var canvas_rect = get_viewport_rect()
	var size = canvas_rect.size / zoom
	var anhor_shift = Vector2.ZERO if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT else -0.5 * size
	var pos = global_position + anhor_shift
	_state._viewport_rect = Rect2(pos, size)

func _on_mode_changed(mode):
	if mode is MainCameraState.FreeMode:
		pass
	if mode is MainCameraState.TargetMode:
		pass
		
func _process(delta):
	if _state.mode is MainCameraState.TargetMode:
		position = _state.mode.target.position
	
