@tool
class_name ItemActionResource
extends ActionResource

const ACTION_DECREASE_WHEN_ACTIVATE = "DECREASE_WHEN_ACTIVATE"
const ACTION_CHANGE_DURABILITY = "CHANGE_DURABILITY"


func _init() -> void:
	super()
	#Actions.merge({
		#DECREASE_WHEN_ACTIVATE = Utils.NUMB_POWERS_2[3],
		#CHANGE_DURABILITY = Utils.NUMB_POWERS_2[4],
	#})


@export var use_stack := false
