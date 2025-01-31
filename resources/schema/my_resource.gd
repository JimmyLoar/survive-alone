class_name  MyResource
extends Resource

var _resource_type: String = "MYRESOURCE"

@export var name_key : StringName = "name_key":
	set(value):
		name_key = value.to_lower()
		visible_name = TranslationServer.translate("%s_NAME_" % [_resource_type] + name_key.to_upper())
		discription = TranslationServer.translate("%s_DISCRIPTION_" % [_resource_type] + name_key.to_upper())

@export_custom(	PROPERTY_HINT_TYPE_STRING, "", 
	PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT
	) var visible_name: String = ""
@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "", 
	PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT
	) var discription : String = ''


func _init(resource_type_name: String = "MYRESOURCE") -> void:
	_resource_type = resource_type_name.to_upper()
