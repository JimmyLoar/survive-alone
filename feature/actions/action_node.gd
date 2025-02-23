class_name ActionNode
extends Node

var _conditions_and_effects: CondisionsAndEffects
var _state: ActionState


func _ready() -> void:
	_state = Injector.provide(ActionState, ActionState.new(self), self, Injector.ContainerType.CLOSEST)
	_conditions_and_effects = Injector.inject(CondisionsAndEffects, self) as CondisionsAndEffects
	print(_conditions_and_effects.get_condition_names())
	print(_conditions_and_effects.get_effect_names())


func execute(action: ActionResource) -> Error:
	if not is_met_conditions(action):
		return 1
	
	for i in action.effects.size():
		var effect: EffectResource = action.effects[i]
		_conditions_and_effects.trigger_effect(effect.name, effect.args)
	return OK


func is_met_conditions(action: ActionResource) -> bool:
	for i in action.conditions.size():
		var condition: ConditionResource = action.conditions[i]
		if not _conditions_and_effects.check_condition(condition.name, condition.get_arguments()):
			return false
	return true 
