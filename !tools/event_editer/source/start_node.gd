class_name StartEventNode
extends EventNode

@export var name_key: String


func get_event_name():
	return TranslationServer.translate(("event_%s_name" % name_key).to_upper())


func get_event_discription():
	return TranslationServer.translate(("event_%s_discription" % name_key).to_upper())
	
