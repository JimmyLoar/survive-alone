extends Node2D


@onready var condition_manager: ConditionManager = $ConditionManager

@onready var _audio_database: AudioDatabase = $AudioDatabase
@onready var _sound_pool_generator: SoundPoolGenerator = $SoundPoolGenerator

@onready var ambience_player: AmbiencePlayer = $AmbiencePlayer
@onready var music_manager: MusicManager = $MusicManager


func _enter_tree() -> void:
	if not Locator.has_service(ConditionManager):
		Locator.add_initialized_service($ConditionManager)
		Locator.add_initialized_service($AmbiencePlayer)
		Locator.add_initialized_service($MusicManager)
	resume_sounds.call_deferred()


func _exit_tree() -> void:
	pause_sounds()


func pause_sounds():
	for player: AudioStreamPlayer in ambience_player.get_children():
		player.stream_paused = true


func resume_sounds():
	for player: AudioStreamPlayer in ambience_player.get_children():
		player.stream_paused = false
