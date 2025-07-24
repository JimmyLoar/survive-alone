class_name MusicManager
extends Node

@export var condition_manager: ConditionManager
@export var sound_database: AudioDatabase

var current_track: String = ""
var active_player: AudioStreamPlayer
var next_player: AudioStreamPlayer

# Запускает музыку по тегам
func play():
	var best_track = _select_best_music_track()
	if best_track != current_track:
		_play_track(best_track)

# Выбирает наиболее подходящий трек
func _select_best_music_track() -> String:
	var best_score = 0.0
	var best_track = ""
	
	for track_id in sound_database.music_tracks:
		var track_data = sound_database.music_tracks[track_id]
		var score = _calculate_music_score(track_data["tags"])
		if score > best_score:
			best_score = score
			best_track = track_id
	return best_track

# Аналогично SoundPoolGenerator, но для музыки
func _calculate_music_score(tags: Array) -> float:
	var score = 0.0
	for tag in tags:
		if condition_manager.active_tags.has(tag):
			score += condition_manager.active_tags[tag]
	return score

# Плавное переключение треков
func _play_track(track_id: String):
	var track_data = sound_database.music_tracks.get(track_id)
	if not track_data: return
	
	# Создаём новый плеер для плавного перехода
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = track_data["stream"]
	new_player.volume_db = -80.0  # Начинаем с тишины
	new_player.play()
	
	# Плавное увеличение громкости
	var fade_in = create_tween()
	fade_in.tween_property(new_player, "volume_db", track_data["volume_db"], track_data["fade_duration"])
	
	# Если был предыдущий трек — плавно его выключаем
	if active_player:
		var fade_out = create_tween()
		fade_out.tween_property(active_player, "volume_db", -80.0, track_data["fade_duration"])
		fade_out.tween_callback(active_player.queue_free)
	
	active_player = new_player
	current_track = track_id
