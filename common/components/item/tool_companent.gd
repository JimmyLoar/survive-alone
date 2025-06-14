class_name ToolItemCompanent
extends ItemComponent


func apply(entity: ItemEntity) -> ItemEntity:
	return super(entity)



func serialize() -> Dictionary:
	return {}


func deserialize(data: Dictionary) -> void:
	pass


func get_type() -> ItemResource.Components:
	return ItemResource.Components.TOOL


func get_type_string() -> String:
	return "tool"
