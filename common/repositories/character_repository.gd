class_name CharacterRepository
extends Injectable

const WORLD_POS_ROW_ID = 1

var _save_db: SaveDb


func _init(save_db: SaveDb) -> void:
	_save_db = save_db


func get_world_position() -> Vector2:
	var select_condition = "id = %d" % WORLD_POS_ROW_ID
	var rows = _save_db.connection.select_rows("character_world_pos", select_condition, ["x", "y"])
	return Vector2(rows[0].x, rows[0].y)


func set_world_position(pos: Vector2):
	var select_condition = "id = %d" % WORLD_POS_ROW_ID
	var row = {"x": pos.x, "y": pos.y}
	_save_db.connection.update_rows("character_world_pos", select_condition, row)


func insert_world_position(pos: Vector2):
	var query = """
			INSERT OR REPLACE INTO character_world_pos 
			(id, x, y) 
			VALUES (?, ?, ?)
		"""
		
	_save_db.connection.query_with_bindings(query, [WORLD_POS_ROW_ID, pos.x, pos.y])
