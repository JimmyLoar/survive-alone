class_name FreeCameraController
extends CameraController
# реализация контроллера камеры на момент боксинга
@export var default_target: Node2D

@export var camera_speed = 100

@export_category('Zoom')
@export var zoom_factor: float = 0.1

@export var max_zoom = 2.0
@export var min_zoom = 0.5

@export var zoom_sensitivity = 30


var events = {}
var last_drag_distance = 0

func zoom_camera(factor:float) -> void:
	# зуум с ограничениями
	_actor.zoom = clamp(
		_actor.zoom + Vector2(factor, factor),
		 Vector2(min_zoom, min_zoom),
		 Vector2(max_zoom, max_zoom)
		)
	# смягчение скачков
	if not _following:
		_move_camera(Vector2.ZERO)
	

func _ready() -> void:
	super._ready() 
	track_default_target()


func _unhandled_input(event) -> void:
	
	# Управление жестами
	
	# Считываем тап регестрируя ивент
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
	
	# Считываем драг
	if event is InputEventScreenDrag:
		events[event.index] = event
		# Если палец на экране один
		if events.size() == 1:
			# Слегка криво обращаемся к зуму камеры чтобы камера двигалась с постоянной скоростью
			_move_camera(-event.relative / _actor.zoom.x)
		# Если палецев два на экране
		if events.size() == 2:
			var drag_distance = events[0].position.distance_to(events[1].position)
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (-zoom_factor) if drag_distance < last_drag_distance else (zoom_factor)
				zoom_camera(new_zoom)
				last_drag_distance = drag_distance
	
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
