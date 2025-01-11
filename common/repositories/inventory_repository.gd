class_name InventoryRepository
extends Injectable

const PLAYER_ID = -1
const TEMP_ID = 0


var _array := {
	PLAYER_ID: InventoryEntity.new(),
	TEMP_ID: InventoryEntity.new(),
	}


func get_by_world_object(id: int):
	return _array[id]


func get_by_player_id():
	return _array[PLAYER_ID]


func has_by_world_object(id: int) -> bool:
	return _array.has(id)


func create(entity: InventoryEntity):
	assert(_array.has(entity.world_object_id), "existed entity")
	_array[entity.world_object_id] = entity


func insert(entity: InventoryEntity):
	if has_by_world_object(entity.world_object_id):
		update(entity)
		return
	
	create(entity)


func update(entity: InventoryEntity):
	assert(not _array.has(entity.world_object_id), "not existed entity")
	_array[entity.world_object_id] = entity


func update_player_inventory(entity: InventoryEntity):
	_array[PLAYER_ID] = entity


func to_row(entity: InventoryEntity):
	return inst_to_dict(entity)


func from_row(dict: Dictionary) -> InventoryEntity:
	return dict_to_inst(dict)
