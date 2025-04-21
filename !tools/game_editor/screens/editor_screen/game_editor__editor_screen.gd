class_name GameEditor__EditorScreen
extends Node2D


@export var data_base_path: String


func _enter_tree() -> void:
	Locator.initialize_service(BiomeRepository, [self])
	Locator.initialize_service(BiomeRectRepository, [self])
	Locator.initialize_service(GameEditor__EditorScreenState)
	Locator.get_service(GameDb).db_connect(data_base_path)
