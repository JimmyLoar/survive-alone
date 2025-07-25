extends Node2D


@onready var condition_manager: ConditionManager = $ConditionManager

@onready var _audio_database: AudioDatabase = $AudioDatabase
@onready var _sound_pool_generator: SoundPoolGenerator = $SoundPoolGenerator

@onready var ambience_player: AmbiencePlayer = $AmbiencePlayer
@onready var music_manager: MusicManager = $MusicManager


func _enter_tree() -> void:
	Locator.add_initialized_service($ConditionManager)
	Locator.add_initialized_service($AmbiencePlayer)
	Locator.add_initialized_service($MusicManager)
