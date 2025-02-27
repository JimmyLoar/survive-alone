class_name  NamedResource
extends Resource

var _resource_type: String = "MYRESOURCE"

@export var code_name : StringName = "code_name":
	set(value):
		code_name = value.to_lower()
		visible_name = TranslationServer.translate("%s_NAME_" % [_resource_type] + code_name.to_upper())
		discription = TranslationServer.translate("%s_DISCRIPTION_" % [_resource_type] + code_name.to_upper())

@export_group("Translation")
@export_custom(	PROPERTY_HINT_TYPE_STRING, "", 
	PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT
	) var visible_name: String = "":
		get(): return TranslationServer.translate("%s_NAME_" % [_resource_type] + code_name.to_upper())
@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "", 
	PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT
	) var discription : String = '':
		get(): return TranslationServer.translate("%s_DISCRIPTION_" % [_resource_type] + code_name.to_upper())


func _init(resource_type_name: String = "MYRESOURCE") -> void:
	_resource_type = resource_type_name.to_upper()
