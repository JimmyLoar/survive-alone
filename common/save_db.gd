class_name SaveDb
extends Injectable

var is_connection_opened: bool:
	get:
		return connection != null
var _path: String = ""
var path: String:
	get:
		return _path

signal connection_changed(connection: SQLite)
var connection: SQLite


func db_connect(connect_path: String):
	if connection != null:
		connection.close_db()

	connection = SQLite.new()
	connection.path = connect_path
	# _db.verbosity_level = SQLite.VERBOSE # only for debug db errors
	connection.verbosity_level = SQLite.QUIET  # for production - without any db errors
	var is_opened = connection.open_db()

	if is_opened:
		_path = connect_path
	else:
		printerr("SaveDb: db %s not opend" % path)
		_path = ""
		connection = null

	var is_table_created = _create_tables_if_not_exist()

	if is_table_created:
		connection_changed.emit(connection)


func _create_tables_if_not_exist() -> bool:
	if not is_connection_opened:
		return false

	var query = """
CREATE TABLE IF NOT EXISTS "character_world_pos" (
	"id"	INTEGER NOT NULL UNIQUE,
	"x"	REAL NOT NULL,
	"y"	REAL NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "character_prop" (
	"name"	TEXT NOT NULL UNIQUE,
	"resource"	BLOB NOT NULL,
	PRIMARY KEY("name")
);
CREATE TABLE IF NOT EXISTS "inventory" (
	"id"	INTEGER NOT NULL UNIQUE,
	"belongs_at_object_id"	INTEGER NOT NULL,
	"belongs_at_object_type"	INTEGER NOT NULL,
	"items"	BLOB NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
"""
	if not connection.query(query):
		return false

	return true


func db_close():
	if connection != null:
		connection.close_db()

	_path = ""
	connection = null
	connection_changed.emit(connection)
