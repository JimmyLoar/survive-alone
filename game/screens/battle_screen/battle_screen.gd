class_name BattleScreen extends Node2D




@onready var _progress_window: Window = $ProgressWindow
@onready var _reward_window: RewardDialog = $RewardWindow

var _enemies: Array
var _weapons: Array


func _ready() -> void:
	_reward_window.hide()
	_progress_window.show()
	_progress_window.start()


func set_weapons(weapons: Array):
	_weapons = _enemies


func set_enemies(enemies: String, group_name: String = "врагов"):
	_enemies = enemies.split(",")
	var _name := group_name if _enemies.size() > 1 else _enemies.front() as String
	_progress_window.title = "Бой против %s" % [_name.capitalize()]


func _show_result(is_win: bool = true):
	_progress_window.hide()
	_reward_window.set_items(_get_rewards_from_enemies())
	_reward_window.show_result("win!" if is_win else "lose")
	Locator.get_service(GameState).is_win_last_battle = is_win


func _get_rewards_from_enemies() -> Array[ItemEntity]:
	return []


func _on_reward_window_close_requested() -> void:
	var game_path = ProjectSettings.get_setting("databases/game_database_path")
	var save_path = ProjectSettings.get_setting("databases/save_database_path")
	Locator.get_service(GameState).open_world_screen(game_path, save_path)










 
