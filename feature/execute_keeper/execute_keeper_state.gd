@tool
class_name ExecuteKeeperState
extends Injectable

const PATH = "res://!saves/condition_effects_names.cfg"
const CONDITION_KEY = "condition"
const EFFECT_KEY = "effect"
const NONE_NAME = "none"

static var _types: PackedStringArray = [
	CONDITION_KEY, 
	EFFECT_KEY,
]
var _storage: Dictionary = {}


func _init() -> void:
	for type in _types:
		_storage[type] = {}


# Регистрация кастомного метода
func register(type: String, id: String, callback: Callable, args_type: Array = [], args_default: Array[Variant] = []) -> void:
	_storage[type][id] = callback
	_save_config(type, id, [args_type, args_default])


# Вызов кастомного метода
func execute(resource: ExecuteKeeperResource) -> Variant:
	var callbacks: Dictionary = _storage.get(resource.type, {})
	if callbacks.is_empty():
		push_error("type '%s' have not methods to execute!", resource.type)
		return null
	return callbacks.get(resource.name).callv(resource.args_data)


# Получение массива имён зарегистрированых методов 
static func get_names(type: String) -> PackedStringArray:
	var config: ConfigFile = _load_config()
	return config.get_section_keys(type)


# Получение массива аргументов (тип, значение поумолчанию) зарегистрированых методов
static func get_args(type: String, name: String) -> Array:
	var config: ConfigFile = _load_config()
	var data = config.get_value(type, name)
	if not data:
		return [[], []]
	return data


static func _load_config():
	var config := ConfigFile.new()
	if config.load(PATH) == OK:
		return config
	
	var new := ConfigFile.new()
	for type in _types:
		new.set_value(type, NONE_NAME, [[], []])
	return new


func _save_config(type: String, id: String, value: Array = [[], []]):
	if OS.is_debug_build():
		var config: ConfigFile = _load_config()
		config.set_value(type, id, value)
		config.save(PATH)
	
