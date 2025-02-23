class_name CondisionsAndEffects
extends Injectable

const PATH = "res://!saves/condition_effects_names.cfg"
const CONDITION_KEY = "conditions"
const EFFECT_KEY = "effects"

var _conditions: Dictionary = {}
var _effects: Dictionary = {}


# Регистрация кастомного условия
func register_condition(id: String, callback: Callable, args_type: Array = [], args_default: Array[Variant] = []) -> void:
	_conditions[id] = callback
	_save_config(CONDITION_KEY, id, [args_type, args_default])


# Регистрация кастомного эффекта
func register_effect(id: String, callback: Callable, args_type: Array = [], args_default: Array[Variant] = []) -> void:
	_effects[id] = callback
	_save_config(EFFECT_KEY, id, [args_type, args_default])


# Проверка кастомного условия
func check_condition(id: String, args: Array) -> bool:
	return _conditions.get(id, func(_a): return false).call(args)


# Выполнение кастомного эффекта
func trigger_effect(id: String, args: Array) -> void:
	var effect = _effects.get(id, func(_a): pass)
	effect.call(args)


static func get_effect_names() -> PackedStringArray:
	var config: ConfigFile = _load_config()
	return config.get_section_keys(EFFECT_KEY)


static func get_condition_names() -> PackedStringArray:
	var config: ConfigFile = _load_config()
	return config.get_section_keys(CONDITION_KEY)


static func get_condition_arg_types(name: String) -> Array:
	var config: ConfigFile = _load_config()
	return config.get_value(CONDITION_KEY, name)[0]


static func get_condition_args_default(name: String) -> Array:
	var config: ConfigFile = _load_config()
	return config.get_value(CONDITION_KEY, name)[1]


static func get_effect_arg_types(name: String) -> Array:
	var config: ConfigFile = _load_config()
	return config.get_value(EFFECT_KEY, name)[0]


static func get_effect_args_default(name: String) -> Array:
	var config: ConfigFile = _load_config()
	return config.get_value(EFFECT_KEY, name)[1]


static func _load_config():
	var config := ConfigFile.new()
	if config.load(PATH) == OK:
		return config
	return ConfigFile.new()


func _save_config(type: String, id: String, value: Array = [[], []]):
	var config: ConfigFile = _load_config()
	config.set_value(type, id, value)
	config.save(PATH)
