class_name AmbiencePlayer
extends Node

@export var pool_generator: SoundPoolGenerator
@export var audio_database: AudioDatabase 
@export var max_simultaneous_sounds: int = 4

var current_pool: Array = []
var active_players: Array = []
var persistent_players: Dictionary = {}  # { "sound_id": AudioStreamPlayer }


func _ready():
	pool_generator.condition_manager.conditions_updated.connect(_update_pool)
	_update_pool()
	_play_loop()


func _update_pool():
	current_pool = pool_generator.generate_pool()
	_update_persistent_sounds()


func _update_persistent_sounds():
	for sound_id in persistent_players.keys().duplicate(): 
		var sound_data = audio_database.get_sound(sound_id)
		var is_active = _is_sound_active(sound_data)
		if not is_active:
			_fade_out_player(persistent_players[sound_id])
			persistent_players.erase(sound_id)
	
	for sound in current_pool:
		if sound.get("is_persistent", false) and not persistent_players.has(sound["id"]):
			_play_persistent_sound(sound)


func _is_sound_active(sound_data: Dictionary) -> bool:
	for tag in sound_data["tags"]:
		if pool_generator.condition_manager.active_tags.has(tag):
			return true
	return false


func _play_persistent_sound(sound: Dictionary):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sound["stream"]
	player.volume_db = sound.get("volume_db", 0.0)
	player.play()
	persistent_players[sound["id"]] = player


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
		var sound = _select_weighted_random_from_pool(non_persistent_pool)
		if sound:
			var player = AudioStreamPlayer.new()
			add_child(player)
			player.stream = sound["stream"]
			player.volume_db = sound.get("volume_db", 0.0)
			player.play()
			active_players.append(player)
			player.finished.connect(_on_player_finished.bind(player))


func _select_weighted_random_from_pool(pool: Array) -> Dictionary:
	if pool.is_empty(): return {}
	
	var total_score = 0.0
	for s in pool: total_score += s["score"]
	
	var rnd = randf() * total_score
	for sound in pool:
		if rnd <= sound["score"]: return sound
		rnd -= sound["score"]
	return pool[0]


func _fade_out_player(player: AudioStreamPlayer, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80.0, duration)
	await tween.finished
	player.stop()
	player.queue_free()


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
