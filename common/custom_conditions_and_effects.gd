class_name CondisionsAndEffects
extends Injectable

var _conditions: Dictionary = {}
var _effects: Dictionary = {}

# Регистрация кастомного условия
func register_condition(id: String, callback: Callable) -> void:
	_conditions[id] = callback

# Регистрация кастомного эффекта
func register_effect(id: String, callback: Callable) -> void:
	_effects[id] = callback

# Проверка кастомного условия
func check_condition(id: String, args: Array) -> bool:
	return _conditions.get(id, func(_a): return false).call(args)

# Выполнение кастомного эффекта
func trigger_effect(id: String, args: Array) -> void:
	var effect = _effects.get(id, func(_a): pass)
	effect.call(args)
