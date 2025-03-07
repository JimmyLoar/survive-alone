class_name CharacterPropertyEntity
extends Resource

var data_name: StringName
var value: float = 0.0:
	set(_value): 
		value = clamp(_value, _min, _max * 2)
var delta: float = 0.0
var _min: float = 0.0: get = get_min_value
var _max: float = 1.0: get = get_max_value


func _init(data: CharacterPropertyResource = null):
	if not data:
		return 
	
	data_name = data.code_name
	if not reset(data):
		breakpoint


func get_min_value(): return _min
func get_max_value(): return _max


func reset(data: CharacterPropertyResource) -> bool:
	if data.code_name != data_name or not data:
		return false
	
	_min = data.default_min_value
	_max = data.default_max_value
	delta = data.default_delta_value
	value = data.default_value
	return true


func serialize() -> PackedByteArray:
	var dict = {
		"data_name": data_name,
		"value": value,
		"max": _max,
		"min": _min,
		"delta": delta,
	}
	return var_to_bytes(dict)


static func deserialize(bytes: PackedByteArray) -> CharacterPropertyEntity:
	var dict = bytes_to_var(bytes)
	var result = CharacterPropertyEntity.new()
	result.data_name = dict["data_name"]
	result._max = dict["max"]
	result._min = dict["min"]
	result.delta = dict["delta"]
	result.value = dict["value"]
	return result
