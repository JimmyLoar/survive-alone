class_name FreeCameraController
extends CameraController
# реализация контроллера камеры на момент боксинга
@export var default_target: Node2D
@export var zoom_factor: float = 0.1

@export var max_zoom = 2.0
@export var min_zoom = 0.5

@export var camera_speed = 100


func zoom_camera(factor:float) -> void:
	# зуум с ограничениями
	_actor.zoom = clamp(
		_actor.zoom + Vector2(factor, factor),
		 Vector2(min_zoom, min_zoom),
		 Vector2(max_zoom, max_zoom)
		)


func _ready() -> void:
	super._ready() 
	track_default_target()


func _unhandled_input(event) -> void:
	# зумм на колесеко мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom_camera(zoom_factor)
	# зумм на колесеко мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_camera(-zoom_factor)
	
	
	# дебаг функции	F - следуем за целью по умолчанию
	if event is InputEventKey and OS.get_keycode_string(event.keycode) == 'F':
		track_default_target()
	# дебаг функции	G - свободный режим камеры
	if event is InputEventKey and OS.get_keycode_string(event.keycode) == 'G':
		camera_free_mode()


func track_default_target() -> void:
	# следуем за целью по умолчанию
	set_camera_target(default_target)


func _process(delta) -> void:
	# дебаг функции	движение камеры на стрелочки 
	super._process(delta)
	var direction = Input.get_vector('camera_debug_left', "camera_debug_right", "camera_debug_up", "camera_debug_down")
	if direction:
		_move_camera(direction * camera_speed * delta)
