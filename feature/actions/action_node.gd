extends Node

var _conditions_and_effects: CondisionsAndEffects
var _state: ActionState


func _ready() -> void:
	_state = Injector.provide(ActionState, ActionState.new(self), self, Injector.ContainerType.CLOSEST)
	_conditions_and_effects = Injector.inject(CondisionsAndEffects, self)


func execute(action: ActionResource) -> Error:
	if not is_met_conditions(action):
		return 1
	return OK


func is_met_conditions(action: ActionResource) -> bool:
	for i in action.conditions.size()
		if not _conditions_and_effects.check_condition(action.conditions[i][0], ):
			return false
	return true 
