class_name GameEditor__EditorScreen
extends Node2D

@export var data_base_path: String

func _enter_tree() -> void:
	var db = Injector.provide(GameDb, GameDb.new(), self)
	Injector.provide(BiomeRepository, BiomeRepository.new(self), self)
	Injector.provide(BiomeRectRepository, BiomeRectRepository.new(self), self)
	Injector.provide(GameEditor__EditorScreenState, GameEditor__EditorScreenState.new(), self)

	db.db_connect(data_base_path)
