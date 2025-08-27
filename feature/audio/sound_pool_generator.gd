class_name SoundPoolGenerator
extends Node

@export var condition_manager: ConditionManager
@export var database: AudioDatabase


func generate_pool() -> Array:
	var pool = []
	for sound in database.sounds.values():
		var score = _calculate_score(sound.tags)
		if score > 0:
			var entry = sound.duplicate()
			entry["score"] = score
			pool.append(entry)
	return pool


func generate_persistent_pool(tag: String) -> Array:
	var pool = []
	for sound in database.get_sounds_by_tag(tag):
		if sound.is_persistent:
			if _is_has_conflict(sound.get("conflicts", [])):
				continue
			
			var entry = sound.duplicate()
			entry["score"] = condition_manager.active_tags.get(tag, 1.0)
			pool.append(entry)
	return pool


func _calculate_score(tags: Array) -> float:
	var score = 0.0
	for tag in tags:
		score += condition_manager.active_tags.get(tag, 0.0)
	return score


func _is_has_conflict(conflicts_array: Array):
	for conflict in conflicts_array:
		if condition_manager.active_tags.has(conflict):
			true
	return false
