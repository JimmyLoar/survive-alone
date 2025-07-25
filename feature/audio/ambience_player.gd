class_name AmbiencePlayer
extends Node

@export var pool_generator: SoundPoolGenerator
@export var sound_database: AudioDatabase
@export var max_simultaneous_sounds: int = 3

# { "tag": { "players": [AudioStreamPlayer], "sounds": [sound_data] } }
var persistent_tag_pools: Dictionary = {}
var active_players: Array = []
var current_pool: Array = []

func _ready():
	pool_generator.condition_manager.conditions_updated.connect(_update_pools)
	_update_pools()
	_play_loop()

func _update_pools():
	current_pool = pool_generator.generate_pool()
	_update_persistent_tag_pools()

func _update_persistent_tag_pools():
	# Собираем все теги, которые сейчас есть в активных звуках
	var active_tags = pool_generator.condition_manager.active_tags.keys()
	
	# 1. Удаляем пулы для тегов, которые больше не активны
	for tag in persistent_tag_pools.keys().duplicate():
		if not active_tags.has(tag):
			_cleanup_tag_pool(tag)
			persistent_tag_pools.erase(tag)
	
	# 2. Добавляем новые пулы для появившихся тегов
	for tag in active_tags:
		if not persistent_tag_pools.has(tag):
			persistent_tag_pools[tag] = {
				"players": [],
				"sounds": []
			}
	
	# 3. Обновляем звуки в каждом пуле тега
	for tag in persistent_tag_pools:
		var tag_pool = persistent_tag_pools[tag]
		tag_pool["sounds"] = _get_persistent_sounds_for_tag(tag)
		
		# Удаляем лишние плееры, если звуков стало меньше
		while tag_pool["players"].size() > tag_pool["sounds"].size():
			var player = tag_pool["players"].pop_back()
			player.queue_free()
		
		# Добавляем недостающие плееры
		while tag_pool["players"].size() < tag_pool["sounds"].size():
			var player = AudioStreamPlayer.new()
			add_child(player)
			tag_pool["players"].append(player)
		
		# Обновляем все плееры для этого тега
		for i in range(tag_pool["sounds"].size()):
			var sound = tag_pool["sounds"][i]
			var player = tag_pool["players"][i]
			
			if player.stream != sound["stream"] or not player.playing:
				player.stream = sound["stream"]
				player.volume_db = sound.get("volume_db", 0.0)
				player.play()

func _get_persistent_sounds_for_tag(tag: String) -> Array:
	var result = []
	for sound_id in sound_database.sounds:
		var sound = sound_database.get_sound(sound_id)
		if sound.get("is_persistent", false) and sound["tags"].has(tag):
			result.append(sound)
	return result

func _cleanup_tag_pool(tag: String):
	if not persistent_tag_pools.has(tag):
		return
	
	for player in persistent_tag_pools[tag]["players"]:
		player.queue_free()
	
	persistent_tag_pools.erase(tag)

func _play_loop():
	while true:
		if current_pool.size() > 0:
			_play_random_non_persistent_sound()
		await get_tree().create_timer(_get_next_delay()).timeout

func _play_random_non_persistent_sound():
	var non_persistent_pool = []
	for sound in current_pool:
		if not sound.get("is_persistent", false):
			non_persistent_pool.append(sound)
	
	if non_persistent_pool.size() > 0:
		var sound = _select_weighted_random(non_persistent_pool)
		if sound:
			var player = AudioStreamPlayer.new()
			add_child(player)
			player.stream = sound["stream"]
			player.volume_db = sound.get("volume_db", 0.0)
			player.play()
			active_players.append(player)
			player.finished.connect(_on_player_finished.bind(player))

func _select_weighted_random(pool: Array) -> Dictionary:
	if pool.is_empty(): return {}
	
	var total_score = 0.0
	for s in pool: total_score += s["score"]
	
	var rnd = randf() * total_score
	for sound in pool:
		if rnd <= sound["score"]: return sound
		rnd -= sound["score"]
	return pool[0]

func _get_next_delay() -> float:
	if current_pool.is_empty(): return 1.0
	
	var avg_cooldown = 0.0
	var count = 0
	for sound in current_pool:
		if not sound.get("is_persistent", false):
			avg_cooldown += sound["cooldown"]
			count += 1
	
	if count == 0: return 1.0
	avg_cooldown /= count
	return randf_range(avg_cooldown * 0.5, avg_cooldown * 1.5)

func _on_player_finished(player: AudioStreamPlayer):
	active_players.erase(player)
	player.queue_free()
