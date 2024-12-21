extends Node
class_name CameraController

var _actor := Camera2D.new(): set = set_actor
var _camera_target: Node2D
var _following: bool = false: set = _set_follow



func set_actor(new_actor: Camera2D) -> void:
	# Устанавливает предмет движения контролера
	_actor = new_actor


func zoom_camera(factor: float) -> void:
	# Приближение камера на factor
	_actor.zoom += Vector2(factor, factor)


func set_camera_target(target: Node2D) -> void:
	# Устанавливает камере новую цель для следования (Node2D) и переводит камеру в режим следования
	_camera_target = target
	_following = true


func camera_free_mode() -> void:
	# Переводит камеру в свободный режим
	_following = false


func _set_follow(new_state: bool) -> void:
	# Не возможно следование при отсутствии обьекта, камера останется в свободном режиме
	if _camera_target:
		_following = new_state
	else:
		_following = false


func _move_camera(step: Vector2) -> void:
	# При передвижении камеры контролером режим следования отрубаем
	if _following:
		camera_free_mode()
	if _actor:
		if not _following:
			_actor.position += step	
	#TODO Убрать магические числа
		_actor.position.x = clamp(_actor.position.x, _actor.limit_left + 640 / _actor.zoom.x, _actor.limit_right- 640 / _actor.zoom.x)
		_actor.position.y = clamp(_actor.position.y, _actor.limit_top + 360 / _actor.zoom.y, _actor.limit_bottom - 360 / _actor.zoom.y)


func _ready() -> void:
	# Изначально следуем за целью если она есть
	if _camera_target:
		if _actor:
			_actor.position = _camera_target.position
			_actor.reset_smoothing()
			_following = true
		else:
			print('controller without camera')
	else:
		print('camera without target')


func _process(_delta) -> void:
	# В режиме следования перемещаем камеру к обьекту следования
	if _actor:
		if _following:
			_actor.position = _camera_target.position
			
