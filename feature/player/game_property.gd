@tool
class_name GameProperty
extends MyResource

@export var extend: GameProperty: set = _set_extend

@export var texture: Texture

@export_group("Default value", "default_")
@export_range(-1, 4.29497e+06, 0.001) var default_value: float = -1
@export_range(1, 4.29497e+06, 0.001) var default_max_value: float = 100
@export_range(0, 4.29497e+06, 0.001) var default_min_value: float = 0
@export_range(-2.14748e+06, 2.14748e+06, 0.001) var default_delta_value: float = 0

@export var modulate: Color = Color.WHITE


func _init() -> void:
	_resource_type = "PROPERTY"


func _set_extend(value: GameProperty) -> void:
	if not value: 
		return
	
	name_key = value.name_key
	
	default_value = value.default_value
	default_max_value = value.default_max_value
	default_min_value = value.default_min_value
	default_delta_value = value.default_delta_value
	
	modulate = value.modulate
	return