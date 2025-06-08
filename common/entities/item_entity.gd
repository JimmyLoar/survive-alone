class_name ItemEntity
extends RefCounted


var _resource_uid: String
var _resource: ItemResource
var _not_used_amount: int = 0

var _storage_companent: StorageComponent
var _components := []


func _init(resource_uid: String, new_amount: Variant = 0) -> void:
	_resource_uid = resource_uid
	_resource = load(resource_uid)
	_init_components()
	_storage_companent.append(new_amount)


var _COMPONENTS = {
	-1: AmountStorageComponent,
	-2: DurabilityStorageComponent,
	ItemResource.Components.WEAPON:		WeaponItemComponent,
	ItemResource.Components.TOOL:		ToolItemCompanent,
	ItemResource.Components.EXPIRED:	ExpiredItemComponent,
}

func _init_components():
	var _initilized = []
	_storage_companent = _create_component(_resource.item_storage_component)
	for component_id in _resource.components:
		if _initilized.has(component_id):
			continue
		_create_component(component_id)


func _create_component(component_id):
	var component: ItemComponent = _COMPONENTS[component_id].new()
	component.apply(self)
	_components.append(_COMPONENTS[component_id].new())
	return component


func get_storage_component() -> StorageComponent:
	return _storage_companent

































































func get_resource() -> ItemResource: return _resource
func get_resource_uid() -> String: return _resource_uid
func get_not_used_amount() -> int: return _not_used_amount


func is_empty():
	return get_total_amount() <= 0


func get_total_amount() -> int:
	return _not_used_amount


func increase_not_used(delta_value: int):
	_not_used_amount += delta_value
	return _not_used_amount


func decrease_total_amount(value: int) -> int:
	value = abs(value)
	value = increase_not_used(value * -1)
	return min(value, 0) * -1  


func serialize() -> PackedByteArray:
	var dict = {}
	dict["uid"] = _resource_uid
	dict["not_used_amount"] = _not_used_amount
	return var_to_bytes(dict)


static func deserialize(bytes: PackedByteArray) -> ItemEntity:
	var dict = bytes_to_var(bytes)
	var result = ItemEntity.new(
		dict["uid"],
		dict["not_used_amount"],
	)
	return result
