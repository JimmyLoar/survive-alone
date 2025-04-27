class_name ActionAggregate
extends Resource


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
