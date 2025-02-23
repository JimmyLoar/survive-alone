class_name ConditionResource
extends Resource

enum Type{
	NONE,
	HAS_PROPERTY,
}

var currect_type: Type = Type.NONE
var condition_name: String = ""

func get_condition_name():
	pass


func get_arguments(type: Type = currect_type) -> Array:
	var args : Array = []
	return args


func _get_property_list() -> Array[Dictionary]:
	var property: Array[Dictionary] = []
	if Engine.is_editor_hint():
		pass
	
	return property
