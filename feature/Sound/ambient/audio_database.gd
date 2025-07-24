class_name AudioDatabase
extends Node

# Все звуки хранятся в виде словаря
var sounds: Dictionary = {
	"forest_day": {
		"stream": null,#preload("res://resources/sounds/day_forest.wav"),
		"tags": ["день", "лес"],
		"cooldown": 10.0,
		"volume_db": -10.0
	},
	"rain": {
		"stream": null,#preload("res://resources/sounds/rain.wav"),
		"tags": ["дождь", "пасмурно"],
		"cooldown": 5.0,
		"volume_db": -5.0
	},
	"bird_01": {
		"stream": load("res://assets/sounds/in_game/birds/Ambience Birds by MoniqueKruger Id-326833.wav"),
		"tags": ["bg_bird", "nature"],
		"cooldown": 5.0,
		"volume_db": -5.0
	},
	"heart_beat_01": {
		"stream": load("res://assets/sounds/in_game/negative/Human, Heartbeat, Cinematic, 54 BPM SND13592.wav"),
		"tags": ["heartbeat", "low_hp", "death"],
		"cooldown": 5.0,
		"volume_db": 10.0
	},
}

var music_tracks: Dictionary = {
	"main_theme": {
		"stream": load("uid://bfjpjy3v5fb2b"), #"res://assets/music/1-1.mp3",
		"tags": ["спокойная", "основная"],
		"fade_duration": 3.0,
		"volume_db": -15.0
	},
}


# Возвращает звук по ID
func get_sound(sound_id: String) -> Dictionary:
	return sounds.get(sound_id, {})
