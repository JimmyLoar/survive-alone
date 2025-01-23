class_name InventoryRepository
extends Injectable

const PLAYER_ID = 0

var _array := [
	InventoryEntity.new(
		PLAYER_ID,
		InventoryEntity.BelongsAtObject.new(-1, InventoryEntity.BelongsAtObject.Type.PLAYER)
	)
]


func get_by_id(id: int):
	return Utils.find_first(_array, func(x): return x.id == id)


func get_by_player_id():
	return get_by_id(PLAYER_ID)


func get_by_belong_at_object(belong_at):
	return Utils.find_first(_array, func(x): return x.belongs_at.is_equal(belong_at))


func has_by_id(id: int) -> bool:
	return Utils.find_first(_array, func(x): return x.id == id)


func create(entity: InventoryEntity):
	assert(_array.has(entity.id), "existed invetory entity with id %s" % entity.id)
	_array.push_back(entity)


func insert(entity: InventoryEntity):
	if has_by_id(entity.id):
		update(entity)
		return

	create(entity)


func update(entity: InventoryEntity):
	assert(not _array.has(entity.id), "not invetory entity with id %s" % entity.id)
	var index = Utils.find_index(_array, func(x): return x.id == entity.id)
	_array[index] = entity


func update_player_inventory(entity: InventoryEntity):
	_array[PLAYER_ID] = entity


func to_row(entity: InventoryEntity):
	return inst_to_dict(entity)


func from_row(dict: Dictionary) -> InventoryEntity:
	return dict_to_inst(dict)
