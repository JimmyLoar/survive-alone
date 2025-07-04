class_name InventoryEntity
extends Node

var id: int
var belongs_at: BelongsAtObject
var items: Array[ItemEntity]


func _init(
	_id: int = -1, _belongs_at: BelongsAtObject = null, _items: Array[ItemEntity] = []
) -> void:
	id = _id
	belongs_at = _belongs_at
	items = _items
	
func deep_clone():
	return InventoryEntity.new(
		id,
		belongs_at.deep_clone(),
		Array(items.map(func(item): return item.deep_clone()), TYPE_OBJECT, "RefCounted", ItemEntity)
	)


class BelongsAtObject:
	var id: int  # Id of object that hold the inventory
	var type: Type  # The object type

	func _init(_id: int, _type: Type) -> void:
		id = _id
		type = _type

	enum Type { 
		PLAYER, 
		WORLD_LOCATION 
	}

	func is_equal(other: BelongsAtObject):
		return id == other.id and type == other.type
		
	func deep_clone():
		return BelongsAtObject.new(
			id, 
			type
		)
