class_name WorldScreen
extends Node2D


@export var character: Character
@export var ter: MarginContainer
@onready var chunk_container: Node2D = $ChunkContainer

var logger = GodotLogger.with("World")


@export var controller: CharacterController

var _player_properties: PlayerProperty
@export_file("*.gd") var time_path: String
@onready var _game_time: GameTimeCounter 
@onready var ui_node: CanvasLayer = $UI


func _init() -> void:
	_game_time = load("res://core/script/class/logic/game_time_counter.gd").new()
	add_child.call_deferred(_game_time)


func _ready() -> void:
	character.changed_chunk.connect(chunk_container.update_region)
	chunk_container.update_region(
		character.get_chunk_position()
		)
	
	start_game()


func start_game():
	logger.info("Game started with date '{hour}:{minut} {day}/{month}/{year}'".format(_game_time.get_date()))


func get_game_time() -> GameTimeCounter:
	return _game_time
	
