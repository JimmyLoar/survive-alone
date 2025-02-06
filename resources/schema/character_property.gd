@tool
class_name CharacterPropertyResource
extends MyResource


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
	
	name_key = value.name_key
	
	default_value = value.default_value
	default_max_value = value.default_max_value
	default_min_value = value.default_min_value
	default_delta_value = value.default_delta_value
	
	modulate = value.modulate
	return

func serialize() -> PackedByteArray:
	var dict = {
		"name_key": name_key,
		"default_value": default_value,
		"default_max_value": default_max_value,
		"default_min_value": default_min_value,
		"default_delta_value": default_delta_value,
		"modulate": [modulate.r, modulate.g, modulate.b , modulate.a],
		"texture_path": texture.resource_path
	}

	return var_to_bytes(dict)

static func deserialize(bytes: PackedByteArray) -> CharacterPropertyResource:
	var dict = bytes_to_var(bytes)

	var result = CharacterPropertyResource.new()
	result.name_key = dict["name_key"]
	result.default_value = dict["default_value"]
	result.default_max_value = dict["default_max_value"]
	result.default_min_value = dict["default_min_value"]
	result.default_delta_value = dict["default_delta_value"]
	result.modulate = Color(dict["modulate"][0], dict["modulate"][1], dict["modulate"][2], dict["modulate"][3])
	result.texture = load(dict["texture_path"])

	return result
