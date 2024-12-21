class_name GameDbOrm
extends Object

const _DB_PATH = "res://content/database.gddb"
const _CHUNKS_FOLDER = "res://content/world/chunks/"

var _db: Database

func _init():
	var _db = ResourceLoader.load_threaded_get(_DB_PATH)

func get_chunk(pos: Vector2i):
	
