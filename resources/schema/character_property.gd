@tool
class_name CharacterPropertyResource
extends NamedResource


@export var extend: CharacterPropertyResource: set = _set_extend

@export var texture: Texture

@export_group("Default value", "default_")
@export_range(-1, 4.29497e+06, 0.001) var default_value: float = -1:
	set(value):
		default_value = clamp(value, default_min_value, default_max_value)
@export_range(1, 4.29497e+06, 0.001) var default_max_value: float = 100
@export_range(0, 4.29497e+06, 0.001) var default_min_value: float = 0
@export_range(-2.14748e+06, 2.14748e+06, 0.001) var default_delta_value: float = 0

@export var modulate: Color = Color.WHITE


func _init() -> void:
	super("PROPERTY")


func _set_extend(value: CharacterPropertyResource) -> void:
	if not value: 
		return
	
	code_name = value.code_name
	
	default_value = value.default_value
	default_max_value = value.default_max_value
	default_min_value = value.default_min_value
	default_delta_value = value.default_delta_value
	
	modulate = value.modulate
	return
