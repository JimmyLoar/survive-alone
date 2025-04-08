class_name EventAction
extends EventNode


@export var text_key: String
@export var is_said := false


func get_text():
	return TranslationServer.translate("ACTION_KEY_%s" % text_key.to_upper())


func serialize() -> Dictionary:
	var data := super()
	data.is_pressed = completed
	return data


func deserialize(data: Dictionary) -> void:
	super(data)
	completed = data.is_pressed
