class_name WorldScreen
extends Node2D

@export var data_base_path: String


func _enter_tree() -> void:
	var db = Injector.provide(GameDb, GameDb.new(), self)
	Injector.provide(BiomeRepository, BiomeRepository.new(self), self)
	Injector.provide(BiomeRectRepository, BiomeRectRepository.new(self), self)
	Injector.provide(WorldObjectRepository, WorldObjectRepository.new(self), self)
	Injector.provide(WorldScreenState, WorldScreenState.new(), self)

	db.db_connect(data_base_path)
