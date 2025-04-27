class_name ActionAggregate
extends Resource


var _logger := Log.get_global_logger().with("Action")


func _init() -> void:
	if get_script() == ActionAggregate:
		push_error("ActionAggregate нельзя инстанциировать напрямую!")
		self.free()


func is_meet_conditions() -> bool:
	return false


func execute() -> Variant:
	if is_meet_conditions():
		pass
	return 0


func get_action_name() -> String:
	return "action"


func get_arguments_to_method(method) -> Array:
	return []


func get_methods_names() -> Array[String]:
	return []


func get_argument_names(method) -> Array:
	return []
