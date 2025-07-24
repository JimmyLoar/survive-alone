class_name AmbiencePlayer
extends Node

@export var pool_generator: SoundPoolGenerator
@export var max_simultaneous_sounds: int = 8

var current_pool: Array = []
var active_players: Array = []

func _ready():
	pool_generator.condition_manager.conditions_updated.connect(_update_pool)
	_update_pool()
	_play_loop()

# Обновляет пул при изменении условий
func _update_pool():
	current_pool = pool_generator.generate_pool()

# Основной цикл воспроизведения
func _play_loop():
	while true:
		if current_pool.size() > 0:
			_play_random_sound()
		await get_tree().create_timer(_get_next_delay()).timeout

# Проигрывает случайный звук из пула
func _play_random_sound():
	if active_players.size() >= max_simultaneous_sounds:
		return
	
	var sound = _select_weighted_random()
	if sound:
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = sound["stream"]
		player.volume_db = sound.get("volume_db", 0.0)
		player.play()
		
		active_players.append(player)
		player.finished.connect(_on_player_finished.bind(player))

# Выбирает звук с учётом весов
func _select_weighted_random() -> Dictionary:
	var total_score = 0.0
	for sound in current_pool:
		total_score += sound["score"]
	
	var rnd = randf() * total_score
	for sound in current_pool:
		if rnd <= sound["score"]:
			return sound
		rnd -= sound["score"]
	return {}

# Удаляет завершившийся плеер
func _on_player_finished(player: AudioStreamPlayer):
	active_players.erase(player)
	player.queue_free()

# Возвращает случайную задержку до следующего звука
func _get_next_delay() -> float:
	if current_pool.is_empty():
		return 1.0
	var avg_cooldown = 0.0
	for sound in current_pool:
		avg_cooldown += sound["cooldown"]
	avg_cooldown /= current_pool.size()
	return randf_range(avg_cooldown * 0.5, avg_cooldown * 1.5)
