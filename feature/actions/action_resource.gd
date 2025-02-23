@tool
class_name ActionResource
extends NamedResource


@export var conditions: Array[ConditionResource] = []
@export var effects: Array[EffectResource] = []


var type := 1:
	set(value):
		type = value
		notify_property_list_changed()


func _init(_name := "ACTION") -> void:
	super(_name)
