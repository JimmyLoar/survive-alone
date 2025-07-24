extends Node2D


func _enter_tree() -> void:
	Locator.add_initialized_service($ConditionManager)
	Locator.add_initialized_service($AmbiencePlayer)
	Locator.add_initialized_service($MusicManager)
