class_name CharacterRepository
extends Injectable

const WORLD_POS_ROW_ID = 1

var save_db: SaveDb


func _init(host_node: Node) -> void:
	save_db = Injector.inject(SaveDb, host_node)


func get_world_position() -> Vector2:
	var select_condition = "id = %d" % WORLD_POS_ROW_ID
	var rows = save_db.connection.select_rows("character_world_pos", select_condition, ["x", "y"])

	return Vector2(rows[0].x, rows[0].y)


func set_world_position(pos: Vector2):
	var select_condition = "id = %d" % WORLD_POS_ROW_ID
	var row = {"x": pos.x, "y": pos.y}
	save_db.connection.update_rows("character_world_pos", select_condition, row)
