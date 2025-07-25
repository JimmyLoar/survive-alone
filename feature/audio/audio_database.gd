class_name AudioDatabase
extends Node

var sounds: Dictionary = {}
var music_tracks: Dictionary = {}


func _ready() -> void:
	load_from_json("res://feature/audio/sound_database.json")


func load_from_json(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to load sound database")
		return
	
	var data = JSON.parse_string(file.get_as_text())
	if not data:
		push_error("Invalid JSON format")
		return
	
	# Load sounds
	sounds.clear()
	for sound_id in data.get("sounds", {}):
		var sound = data["sounds"][sound_id]
		sounds[sound_id] = {
			"stream": load("res://sound_system/resources/" + sound.path),
			"tags": sound.tags,
			"cooldown": sound.get("cooldown", 0.0),
			"volume_db": sound.get("volume_db", 0.0),
			"is_persistent": sound.get("is_persistent", false)
		}
	
	# Load music
	music_tracks.clear()
	for track_id in data.get("music", {}):
		var track = data["music"][track_id]
		music_tracks[track_id] = {
			"stream": load("res://sound_system/resources/" + track.path),
			"tags": track.tags,
			"fade_duration": track.get("fade_duration", 1.0),
			"volume_db": track.get("volume_db", 0.0)
		}


func get_sounds_by_tag(tag: String) -> Array:
	var result = []
	for sound in sounds.values():
		if tag in sound.tags:
			result.append(sound)
	return result
