class_name EventAction
extends EventNode


@export var text_key: String


func get_text():
	return TranslationServer.translate("ACTION_KEY_%s" % text_key.to_upper())
