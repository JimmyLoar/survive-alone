@tool
class_name ActionResource
extends NamedResource


@export var conditions: Array[ExecuteKeeperResource] = []: set = set_conditions
@export var effects: Array[ExecuteKeeperResource] = []: set = set_effects


var type := 1:
	set(value):
		type = value
		notify_property_list_changed()


func _init(_name := "ACTION") -> void:
	super(_name)


func set_conditions(value: Array[ExecuteKeeperResource]):
	conditions = value
	for i in value.size():
		if conditions[i] is not ExecuteKeeperResource:
			continue
		
		conditions[i].type = ExecuteKeeperState.CONDITION_KEY


func set_effects(value: Array[ExecuteKeeperResource]):
	effects = value
	for i in value.size():
		if effects[i] is not ExecuteKeeperResource:
			continue
		
		effects[i].type = ExecuteKeeperState.EFFECT_KEY
