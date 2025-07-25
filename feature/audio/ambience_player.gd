class_name AmbiencePlayer
extends Node

@export var pool_generator: SoundPoolGenerator
@export var max_sounds: int = 5

var active_players: Array = []
var persistent_players: Dictionary = {}  # { "tag": [players] }

func _ready() -> void:
	pool_generator.condition_manager.tag_added.connect(_on_tag_added)
	pool_generator.condition_manager.tag_removed.connect(_on_tag_removed)
	_play_ambience_loop()

func _on_tag_added(tag: String) -> void:
	var pool = pool_generator.generate_persistent_pool(tag)
	if pool.is_empty():
		return
	
	if not persistent_players.has(tag):
		persistent_players[tag] = []
	
	# Create players for persistent sounds
	for sound in pool:
		var player = _create_player(sound)
		persistent_players[tag].append(player)


func _on_tag_removed(tag: String) -> void:
	if persistent_players.has(tag):
		for player in persistent_players[tag]:
			player.queue_free()
		persistent_players.erase(tag)


func _play_ambience_loop() -> void:
	while true:
		var pool = pool_generator.generate_pool()
		var non_persistent = _filter_non_persistent(pool)
		
		if non_persistent.size() > 0 and active_players.size() < max_sounds:
			var sound = _select_random(non_persistent)
			var player = _create_player(sound)
			active_players.append(player)
		
		await get_tree().create_timer(1.0).timeout

func _create_player(sound: Dictionary) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sound.stream
	player.volume_db = sound.volume_db
	player.bus = "Ambience"
	player.play()
	player.finished.connect(_on_player_finished.bind(player))
	return player

func _on_player_finished(player: AudioStreamPlayer) -> void:
	active_players.erase(player)
	player.queue_free()

func _filter_non_persistent(pool: Array) -> Array:
	return pool.filter(func(sound): return not sound.get("is_persistent", false))

func _select_random(pool: Array) -> Dictionary:
	var total = pool.reduce(func(sum, s): return sum + s.score, 0.0)
	var r = randf_range(0, total)
	var accum = 0.0
	for sound in pool:
		accum += sound.score
		if r <= accum:
			return sound
	return pool[0]
