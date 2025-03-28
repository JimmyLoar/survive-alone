class_name InventoryRepository
extends Injectable

var _save_db: SaveDb
var TABLE_NAME = "inventory"
const PLAYER_ID = 1


func  _init(save_db: SaveDb) -> void:
	_save_db = save_db

func get_by_id(id: int) -> InventoryEntity:
	var select_condition = "id = %d" % id
	var row = _save_db.connection.select_rows(
		TABLE_NAME, select_condition, ["id", "belongs_at_object_id", "belongs_at_object_type", "items"]
	)
	if row.size() == 0:
		return null
	return _row_to_entity(row[0]) as InventoryEntity


func get_by_player_id() -> InventoryEntity:
	return get_by_id(PLAYER_ID)


func get_by_belong_at_object(belong_at: InventoryEntity.BelongsAtObject):
	var select_condition = "belongs_at_object_id = %d AND belongs_at_object_type = %d" % [belong_at.id, int(belong_at.type)]
	var row = _save_db.connection.select_rows(
		TABLE_NAME, select_condition, ["id", "belongs_at_object_id", "belongs_at_object_type", "items"]
	)
	if row.size() == 0:
		return null
	return _row_to_entity(row[0]) as InventoryEntity


func has_by_id(id: int) -> bool:
	if id < 0:
		return false
	var select_condition = "id = %d" % id
	var rows = _save_db.connection.select_rows(TABLE_NAME, select_condition, ["id"])

	return rows.size() > 0


func create(entity: InventoryEntity) -> int:
	_save_db.connection.insert_row(TABLE_NAME, _entity_to_row(entity, true))
	return _save_db.connection.last_insert_rowid


func insert(entity: InventoryEntity) -> void:
	if has_by_id(entity.id):
		update(entity)
	else:
		create(entity)


func update(entity: InventoryEntity) -> void:
	var select_condition = "id = %d" % entity.id
	_save_db.connection.update_rows(TABLE_NAME, select_condition, _entity_to_row(entity))


func update_player_inventory(entity: InventoryEntity) -> void:
	assert(entity.id != PLAYER_ID, "update_player_inventory can used only with player inventory")
	update(entity)

func delete(id: int):
	var select_condition = "id = %d" % id
	_save_db.connection.delete_rows(TABLE_NAME, select_condition)

func _entity_to_row(entity: InventoryEntity, without_id = false) -> Dictionary:
	var result = {}

	if not without_id:
		result["id"] = entity.id
	result["belongs_at_object_id"] = entity.belongs_at.id
	result["belongs_at_object_type"] = entity.belongs_at.type
	result["items"] = var_to_bytes(entity.items.map(func(item: ItemEntity): return item.serialize()))

	return result


func _row_to_entity(dict: Dictionary) -> InventoryEntity:
	var _belongs_at = InventoryEntity.BelongsAtObject.new(
		dict["belongs_at_object_id"],
		dict["belongs_at_object_type"],
	)

	# Shitty gdscript static typing
	# https://forum.godotengine.org/t/cast-untyped-array-to-typed-array/50135
	# https://github.com/godotengine/godot/issues/72620
	var items: Array[ItemEntity]
	items.assign(bytes_to_var(dict["items"]).map(func(_bytes: PackedByteArray): return ItemEntity.deserialize(_bytes)))
	
	var result = InventoryEntity.new(
		dict["id"],
		_belongs_at,
		items
	)

	return result
