class_name SoundPoolGenerator
extends Node

@export var condition_manager: ConditionManager
@export var sound_database: AudioDatabase

# Формирует пул звуков на основе активных тегов
func generate_pool() -> Array:
	var pool = []
	for sound_id in sound_database.sounds:
		var sound_data = sound_database.get_sound(sound_id)
		var score = _calculate_match_score(sound_data["tags"])
		if score > 0:
			var sound_entry = sound_data.duplicate()
			sound_entry["id"] = sound_id
			sound_entry["score"] = score
			pool.append(sound_entry)
	return pool

# Вычисляет рейтинг соответствия звука текущим тегам
func _calculate_match_score(sound_tags: Array) -> float:
	var score = 0.0
	for tag in sound_tags:
		if condition_manager.active_tags.has(tag):
			score += condition_manager.active_tags[tag]
	return score
