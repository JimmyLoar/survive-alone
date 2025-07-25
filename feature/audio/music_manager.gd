extends Node
class_name MusicManager

@export var condition_manager: ConditionManager
@export var database: AudioDatabase

var current_track: AudioStreamPlayer
var next_track: AudioStreamPlayer

func _ready() -> void:
	condition_manager.conditions_updated.connect(_update_music)
	_update_music()


func play():
	_update_music()


func _update_music() -> void:
	var best_track = _find_best_track()
	if best_track:
		_play_track(best_track)

func _find_best_track() -> Dictionary:
	var best_score = 0.0
	var best_track = {}
	
	for track in database.music_tracks.values():
		var score = _calculate_score(track.tags)
		if score > best_score:
			best_score = score
			best_track = track
	
	return best_track

func _calculate_score(tags: Array) -> float:
	var score = 0.0
	for tag in tags:
		score += condition_manager.active_tags.get(tag, 0.0)
	return score

func _play_track(track: Dictionary) -> void:
	if current_track and current_track.stream == track.stream:
		return
	
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = track.stream
	new_player.volume_db = -80  # Start muted
	new_player.play()
	new_player.bus = "Music"
	
	# Fade in new track
	var fade_in = create_tween()
	fade_in.tween_property(new_player, "volume_db", track.volume_db, track.fade_duration)
	
	# Fade out current track
	if current_track:
		var fade_out = create_tween()
		fade_out.tween_property(current_track, "volume_db", -80, track.fade_duration)
		fade_out.tween_callback(current_track.queue_free)
	
	current_track = new_player
