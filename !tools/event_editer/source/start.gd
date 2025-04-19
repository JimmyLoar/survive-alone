class_name EventStart
extends EventNode

@export var name_key: String

var active: bool


func get_active() -> bool:
	return active


func get_completed() -> bool:
	return active


func serialize() -> Dictionary:
	var data := super()
	data.active = active
	return data


func deserialize(data: Dictionary) -> void:
	super(data)
	active = data.active


func get_event_name():
	return TranslationServer.translate(("event_%s_name" % name_key).to_upper())


func get_event_discription():
	return TranslationServer.translate(("event_%s_discription" % name_key).to_upper())
