class_name WorldScreen
extends Node2D


@export var character: Character

@export_file("*.gd") var time_path: String

@onready var ui_node: CanvasLayer = $UI
@onready var chunk_container: Node2D = $ChunkContainer

var logger = GodotLogger.with("World")
var database: Database

var _player_properties: PlayerPropertiesController
var _game_time: GameTimeCounter 


func _init() -> void:
	_game_time = load("res://core/script/class/logic/game_time_counter.gd").new()
	_player_properties = load("res://core/script/singletone/player_property.gd").new()
	add_child.call_deferred(_game_time)
	_game_time.time_updated.connect(_player_properties.update)


func _ready() -> void:
	_player_properties.set_database(database)
	character.changed_chunk.connect(chunk_container.update_region)
	chunk_container.update_region(character.get_chunk_position())
	start_game.call_deferred()


func start_game():
	logger.info("Game started with date '{hour}:{minut} {day}/{month}/{year}'".format(_game_time.get_date()))


func get_game_time() -> GameTimeCounter:
	return _game_time


func get_player_properties() -> PlayerPropertiesController:
	return _player_properties
