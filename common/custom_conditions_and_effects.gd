class_name CondisionsAndEffects
extends Injectable

var _custom_conditions: Dictionary = {}
var _custom_effects: Dictionary = {}

# Регистрация кастомного условия
func register_custom_condition(id: String, callback: Callable) -> void:
	_custom_conditions[id] = callback

# Регистрация кастомного эффекта
func register_custom_effect(id: String, callback: Callable) -> void:
	_custom_effects[id] = callback

# Проверка кастомного условия
func check_custom_condition(id: String, args: Array) -> bool:
	return _custom_conditions.get(id, func(_a): return false).call(args)

# Выполнение кастомного эффекта
func trigger_custom_effect(id: String, args: Array) -> void:
	var effect = _custom_effects.get(id, func(_a): pass)
	effect.call(args)
