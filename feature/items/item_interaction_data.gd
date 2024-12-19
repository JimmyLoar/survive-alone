@tool
class_name ItemIntaractionData
extends MyResource

@export var actions : Array[IAction] = []

@export var reduced_when_used := true
@export var can_stacable := false


func _init() -> void:
	super("Item_Action")


func get_pressed_text():
	return visible_name


func is_used_timer() -> bool:
	return actions.any(func(element): return element is UseTimerAction)


func has_change_properties() -> bool:
	return actions.any(func(element): return element is AddProppertyAction)


func has_change_items() -> bool:
	return actions.any(
		func(element): 
		return (element is ChangeItemsAction)
		)
