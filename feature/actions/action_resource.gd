@tool
class_name ActionResource
extends NamedResource


@export var conditions: Array[ExecuteKeeperResource] = []: set = set_conditions
@export var effects: Array[ExecuteKeeperResource] = []: set = set_effects, get = get_effects

@export_group("Context", "context")
@export var context_show_properties_bar := false
@export var context_use_slider := false


func _init(_name := "ACTION") -> void:
	super(_name)


func set_conditions(value: Array[ExecuteKeeperResource]):
	conditions = value
	for i in value.size():
		if conditions[i] is not ExecuteKeeperResource:
			continue
		
		conditions[i].type = ExecuteKeeperState.TYPE_CONDITION


func set_effects(value: Array[ExecuteKeeperResource]):
	effects = value
	_update_effects()


func get_effects():
	return effects


func _update_effects():
	for i in effects.size():
		if effects[i] is not ExecuteKeeperResource:
			continue
		
		effects[i].type = ExecuteKeeperState.TYPE_EFFECT
		if effects[i].name == "remove self item":
			effects[i].args_data[0] = self.code_name
