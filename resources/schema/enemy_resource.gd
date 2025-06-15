class_name EnemyResource
extends NamedResource

#@export_placeholder("EnemyName") var name_key: String = ""

func _init() -> void:
	super("Enemy")
