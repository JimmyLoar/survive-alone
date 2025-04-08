class_name EventDialogue
extends EventStage


@export var dialogues: Array:
	set(value):
		dialogues = value
		notify_property_list_changed()
