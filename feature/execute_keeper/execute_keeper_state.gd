@tool
class_name ExecuteKeeperState
extends Injectable

## Путь сохранения конфиг файла
const PATH = "res://feature/execute_keeper/execute_keeper.cfg"


const TYPE_CONDITION = "condition"
const TYPE_EFFECT = "effect"

const NONE_NAME = "none"
const EMPTY_STRUCTURE = [[], [], []]


static var _types: PackedStringArray = [
	TYPE_CONDITION, 
	TYPE_EFFECT,
]

var _logger = Log.get_global_logger().with("ExecuteKeeperState")
var _storage: Dictionary = {}


func _init() -> void:
	for type in _types:
		_storage[type] = {}


## Регистрация кастомного метода
func register(type: String, id: String, callback: Callable, 
		args_type: Array = [], args_name: Array = [], args_default: Array[Variant] = []) -> void: 
	_storage[type][id] = callback
	_save_config(type, id, [args_type, args_name, args_default])


func has(type: String, id: String) -> bool:
	var config: ConfigFile = _load_config()
	return config.has_section_key(type, id)


## Вызов кастомного метода
func execute(resource: ExecuteKeeperResource) -> Variant:
	var callbacks: Dictionary = _storage.get(resource.type, {})
	if callbacks.is_empty():
		_logger.error("type '%s' have not methods to execute!", resource.type)
		return null
	
	var callable: Callable = callbacks.get(resource.name, func(): return false)
	var result = callable.callv(resource.args_data)
	_logger.debug("code executed: {\nname: '%s' \ntype: %s\nargs: %s\nresult: %s\n}" %
		[resource.name, resource.type, resource.args_data, result, 
			#"\n".join(get_stack().map(func(dict: Dictionary): return "\"%s\" in %s" % [dict.function, dict.source.get_slice("/", dict.source.get_slice_count("/") - 1)]))
		])
	return result


## Получение массива имён зарегистрированых методов 
static func get_names(type: String) -> PackedStringArray:
	var config: ConfigFile = _load_config()
	if config.has_section(type):
		return config.get_section_keys(type)
	return PackedStringArray()


## Получение массива аргументов (тип, значение поумолчанию) зарегистрированых методов
static func get_args(type: String, name: String) -> Array:
	var config: ConfigFile = _load_config()
	var data = config.get_value(type, name)
	if not data:
		return EMPTY_STRUCTURE
	return data


## Загрузка конфига файла
static func _load_config():
	var config := ConfigFile.new()
	if config.load(PATH) == OK:
		return config
	
	var new := ConfigFile.new()
	for type in _types:
		new.set_value(type, NONE_NAME, EMPTY_STRUCTURE)
	return new


## Сохранение конфиг файла
func _save_config(type: String, id: String, value: Array = EMPTY_STRUCTURE):
	if OS.is_debug_build():
		var config: ConfigFile = _load_config()
		config.set_value(type, id, value)
		
		var source := get_stack()[2] as Dictionary
		source["type"] = type
		config.set_value("<registered from>", id, source)
		
		config.save(PATH)
	
