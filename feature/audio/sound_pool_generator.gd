class_name SoundPoolGenerator
extends Node

@export var condition_manager: ConditionManager
@export var audio_database: AudioDatabase

# Основной метод генерации пула звуков
func generate_pool() -> Array:
	var pool = []
	var active_tags = condition_manager.active_tags
	
	# Собираем все звуки, которые соответствуют активным тегам
	for sound_id in audio_database.sounds_ids:
		var sound_data = audio_database.get_sound(sound_id)
		var score = _calculate_match_score(sound_data["tags"], active_tags)
		
		if score > 0:
			var sound_entry = sound_data.duplicate()
			sound_entry["id"] = sound_id
			sound_entry["score"] = score
			pool.append(sound_entry)
	
	return pool

# Вычисляет рейтинг соответствия звука активным тегам
func _calculate_match_score(sound_tags: Array, active_tags: Dictionary) -> float:
	var score = 0.0
	for tag in sound_tags:
		if active_tags.has(tag):
			score += active_tags[tag]  # Учитываем вес тега
	
	# Увеличиваем вес постоянных звуков, чтобы они точно попадали в пул
	var sound_data = audio_database.get_sound(sound_tags[0]) if sound_tags.size() > 0 else null
	if sound_data and sound_data.get("is_persistent", false):
		score += 100.0  # Большой бонус к весу
	
	return score

# Генерирует отдельный пул для конкретного тега (используется AmbiencePlayer)
func generate_pool_for_tag(tag: String) -> Array:
	var pool = []
	var active_tags = {tag: condition_manager.active_tags.get(tag, 1.0)}
	
	for sound_id in audio_database.sounds:
		var sound_data = audio_database.get_sound(sound_id)
		if sound_data["tags"].has(tag) and sound_data.get("is_persistent", false):
			var sound_entry = sound_data.duplicate()
			sound_entry["id"] = sound_id
			sound_entry["score"] = _calculate_match_score([tag], active_tags)
			pool.append(sound_entry)
	
	return pool

# Проверяет, есть ли постоянные звуки для указанного тега
func has_persistent_sounds_for_tag(tag: String) -> bool:
	for sound_id in audio_database.sounds:
		var sound_data = audio_database.get_sound(sound_id)
		if sound_data["tags"].has(tag) and sound_data.get("is_persistent", false):
			return true
	return false
