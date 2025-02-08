class_name WorldScreen
extends Node2D

@export var game_db_path: String
@export var save_db_path: String


func _enter_tree() -> void:
	var game_db = Injector.provide(GameDb, GameDb.new(), self)
	var save_db = Injector.provide(SaveDb, SaveDb.new(), self)
	Injector.provide(BiomeRepository, BiomeRepository.new(self), self)
	Injector.provide(BiomeRectRepository, BiomeRectRepository.new(self), self)
	Injector.provide(WorldObjectRepository, WorldObjectRepository.new(self), self)
	Injector.provide(WorldScreenState, WorldScreenState.new(), self)
	Injector.provide(CharacterRepository, CharacterRepository.new(self), self)

	game_db.db_connect(game_db_path)
	save_db.db_connect(save_db_path)
