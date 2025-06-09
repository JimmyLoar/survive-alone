class_name ItemEntity
extends RefCounted


var _resource_uid: String
var _resource: ItemResource

var _storage_companent: StorageComponent:
	set(value):
		if not _storage_companent:
			_storage_companent = value
var _components := []


func _init(resource_uid: String, new_amount: Variant = 1) -> void:
	_resource_uid = resource_uid
	_resource = load(resource_uid)
	_init_components()
	_storage_companent.append(new_amount)


static var _COMPONENTS = {
	-1: AmountStorageComponent,
	-2: DurabilityStorageComponent,
	ItemResource.Components.WEAPON:		WeaponItemComponent,
	ItemResource.Components.TOOL:		ToolItemCompanent,
	ItemResource.Components.EXPIRED:	ExpiredItemComponent,
}

func _init_components():
	var _initilized = []
	_storage_companent = _create_component(_resource.storage_component)
	for component_id in _resource.components:
		if _initilized.has(component_id):
			continue
		
		_initilized.append(component_id)
		_components.append(_create_component(component_id))


func _create_component(component_id):
	var component: ItemComponent = _COMPONENTS[component_id].new()
	component.apply(self)
	return component


func get_storage() -> StorageComponent: return _storage_companent
func get_resource() -> ItemResource: return _resource
func get_resource_uid() -> String: return _resource_uid


func is_empty() -> bool:
	return get_storage().get_amount() <= 0


func serialize() -> PackedByteArray:
	var dict = {}
	dict["uid"] = _resource_uid
	dict["storage"] = _storage_companent.serialize()
	return var_to_bytes(dict)


static func deserialize(bytes: PackedByteArray) -> ItemEntity:
	var dict = bytes_to_var(bytes)
	var result = ItemEntity.new(
		dict.uid,
		dict.storage.array if dict.storage.has("array") else dict.storage.amount,
	)
	result._init_components()
	return result
