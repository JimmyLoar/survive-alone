class_name CharacterController
extends Node2D

signal started_move
signal finished_move

@export var _speed: int = 75

var _actor := Node2D.new(): set = set_actor
var _target: Vector2 = Vector2.ZERO : set = set_target

var _moving := false
var game_time: GameTimeCounter


func _init() -> void:
	started_move.connect(_on_started_move)
	finished_move.connect(_on_finished_move)


func _ready() -> void:
	pass
	#game_time = Game.get_world_screen().get_game_time()


func set_actor(new_actor: Node2D):
	_actor = new_actor
	_target = _actor.global_position


func set_target(new_target: Vector2):
	_target = new_target


func start():
	_moving = true
	started_move.emit()


func finish():
	_moving = false
	_target = _actor.global_position
	finished_move.emit()


func is_moving() -> bool:
	return _moving


func _on_started_move():
	game_time.start()


func _on_finished_move():
	game_time.stop()
