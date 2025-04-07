class_name EventDialogue
extends EventNode


@export var dialoges: Array:
	set(value):
		dialoges = value
		notify_property_list_changed()
		print("updated dialoges: %s" % [value])





	
	
