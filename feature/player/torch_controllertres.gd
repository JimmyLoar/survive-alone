class_name TorchController
extends CharacterController

func _physics_process(delta: float) -> void:
	var direction = _actor.global_position.direction_to(_target).snapped(Vector2(0.01, 0.01))
	if direction.is_zero_approx(): 
		return
	
	queue_redraw()
	var motion: Vector2 = direction * _speed * delta
	if motion.length() > _actor.global_position.distance_to(_target):
		finish()
		return
	
	_actor.global_position += motion


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		set_target(get_global_mouse_position())
		start()


func _stop(_value = null):
	finish()


func _draw() -> void:
	var direction = _actor.global_position.direction_to(_target)
	var distance = _actor.global_position.distance_to(_target)
	
	draw_line(
			Vector2.ZERO, 
			direction * distance, 
			Color.RED, 3, true
		)
	
