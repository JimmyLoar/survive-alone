class_name InventoryEntity
extends Node


var world_object_id: int = -1
var items: Array[ItemEntity] = []


func _init(presset_id: int = -1) -> void:
	world_object_id = presset_id
