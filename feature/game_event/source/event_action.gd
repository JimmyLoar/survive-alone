@tool
class_name EventActionResource
extends ActionResource

@export var is_said: bool = false
@export var icon: Texture2D
@export var next_stage: int = -1


func _init() -> void:
	super("EVENT_ACTION")
