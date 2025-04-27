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


func has_method_begin_with(string: String):
	return false
