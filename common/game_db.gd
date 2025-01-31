class_name GameDb
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


# big_size_opt - optimisation to insert milions rows. DONT USE ON PRODUCTION GAME!!!!
func db_connect(connect_path: String, big_size_opt = false):
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
		printerr("GameDb: db %s not opend" % path)
		_path = ""
		connection = null

	var is_table_created = _create_tables_if_not_exist(big_size_opt)

	if is_table_created:
		connection_changed.emit(connection)


func _create_tables_if_not_exist(big_size_opt = false) -> bool:
	if not is_connection_opened:
		return false

	var query = """
CREATE TABLE IF NOT EXISTS "biome" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"type"	INTEGER NOT NULL,
	"search_drop_uid"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
) ;
CREATE TABLE IF NOT EXISTS "biome_rect" (
	"id"	INTEGER NOT NULL UNIQUE,
	"x"	INTEGER NOT NULL,
	"y"	INTEGER NOT NULL,
	"end_x"	INTEGER NOT NULL,
	"end_y"	INTEGER NOT NULL,
	"biome_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
	FOREIGN KEY("biome_id") REFERENCES "biome"("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "world_object" (
	"id"	INTEGER NOT NULL UNIQUE,
	"x"	INTEGER NOT NULL,
	"y"	INTEGER NOT NULL,
	"end_x"	INTEGER NOT NULL,
	"end_y"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
"""
	if not connection.query(query):
		return false

	if big_size_opt:
		(
			connection
			. query(
				"""
PRAGMA synchronous = 0;
PRAGMA journal_mode = OFF;
PRAGMA cache_size = 1000000;
PRAGMA locking_mode = EXCLUSIVE;
PRAGMA temp_store = MEMORY;
"""
			)
		)
	else:
		if not create_indexes():
			return false

	return true


func db_close():
	if connection != null:
		connection.close_db()

	_path = ""
	connection = null
	connection_changed.emit(connection)


func create_indexes() -> bool:
	return true
# 	if not is_connection_opened:
# 		return false

# 	var query = """
# CREATE INDEX IF NOT EXISTS "tile_position" ON "tile" (
# 	"x",
# 	"y"
# );
# """

# 	return connection.query(query)
