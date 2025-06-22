class_name Inventory
extends PanelContainer

signal changed_entity(entity: InventoryEntity)

@export var inventory_display : InventoryPageDisplay
@export var item_information : ItemInformation

@onready var _inventory_repository: InventoryRepository = Locator.get_service(InventoryRepository)

var _entity: InventoryEntity = InventoryEntity.new(): set = change_entity
var _stored_cache: Dictionary = {}
var _logger: Log 


func _init(new_name := "Inventory") -> void:
	name = new_name
	_logger = Log.get_global_logger().with("%s " % new_name)
	changed_entity.connect(_recount_index_items)


func _ready() -> void:
	changed_entity.connect(inventory_display.set_entity)
	var summed: SummedInventory = Locator.get_service(SummedInventory)
	if not summed:
		summed = Locator.initialize_service(SummedInventory)
	
	summed.add_inventory(self)
	_logger.debug("Ready!")


func change_entity(_new_entity: InventoryEntity) -> InventoryEntity:
	var tmp = _entity
	if _entity:
		_entity.changed_items_list.disconnect(emit_signal.bind("changed_entity", _entity))
	
	_entity = _new_entity
	if _entity:
		_entity.changed_items_list.connect(emit_signal.bind("changed_entity", _entity))
	
	changed_entity.emit(_new_entity)
	return tmp


func is_empty() -> bool:
	return _entity.items.size() == 0


func add_item(uid: String, value: Variant = 0) -> ItemEntity:
	var item = get_or_create_item(uid)
	item.get_storage().append(value)
	_logger.debug("Added [color=green]%d[/color] items [color=green]%s[/color]" % 
		[value, load(uid).code_name])
	return item


func remove_item(_name: String, _amount := 1):
	if _amount <= 0: 
		return 0
	
	var remaining = _amount
	var index := find_item(_name)
	var item := get_item(index) as ItemEntity
	if index == -1 or not item:
		_logger.warn("Failed remove data [color=green]%s (%d)[/color], become inventory have not this data!" % [name, remaining])
		return remaining
	
	var storage := item.get_storage()
	remaining = _amount - abs(storage.remove(_amount))
	
	if storage.get_amount() <= 0:
		_remove_from_storage_entity(index)
	_logger.debug("Removed [color=green]%d (remaing %d)[/color] items | [color=green]%s (%d)[/color]" % [_amount, remaining, name, storage.get_amount()])
	return remaining


func has_data(_name: String):
	return find_item(_name) != -1


func has_item_amount(_name: String, amount: int = 1) -> bool:
	amount = abs(amount)
	var index := find_item(_name)
	if index != -1:
		return get_item(index).get_storage().get_amount() >= amount
	return false #возвращается если предмета нет в инветоре


func find_item(item_name: String) -> int:
	if _stored_cache.has(item_name):
		return _stored_cache[item_name]
	return -1


func find_and_get_amount(item_name: String) -> int:
	var index = find_item(item_name)
	if index == -1:
		return 0
	return get_item(index).get_storage().get_amount()


func get_item(index: int) -> ItemEntity:
	if is_index_validate(index):
		return _entity.items[index]
	return null


func fetch_item(item_name: StringName) -> ItemEntity:
	return get_item(find_item(item_name))


func fetch_item_data(item_name: StringName) -> ItemResource:
	return fetch_item(item_name).get_resource()


func is_index_validate(index: int) -> bool:
	return index >= 0 and index < _entity.items.size()


func get_or_create_item(uid: String) -> ItemEntity:
	var index = find_item(load(uid).code_name)
	if index == -1:
		return _add_in_storage_entity(ItemEntity.new(uid))
	return get_item(index)


func _add_in_storage_entity(item: ItemEntity) -> ItemEntity:
	var _index: int = _entity.items.size()
	_entity.items.append(item)
	changed_entity.emit(_entity)
	_stored_cache[item.get_resource().code_name] = _index
	item.get_storage().quantity_changed.connect(_on_changed_value.bind(item.get_resource().code_name))
	return item


func _remove_from_storage_entity(index: int) -> ItemEntity:
	if is_index_validate(index):
		var item: ItemEntity = _entity.items.pop_at(index)
		_stored_cache.erase(item.get_resource().code_name)
		changed_entity.emit(_entity)
		item.get_storage().quantity_changed.disconnect(_on_changed_value)
		return item
	return null


func _on_changed_value(value: int, index: String):
	if value <= 0:
		_remove_from_storage_entity(find_item(index))


func _recount_index_items(entity: InventoryEntity):
	for i in entity.items.size():
		_stored_cache[entity.items[i].get_resource().code_name] = i


func get_inventory_size() -> int: 
	if not _entity: 
		return 0
	return _entity.items.size()


func get_items() -> Array[ItemEntity]: 
	if not _entity: 
		return []
	return _entity.items.duplicate()


func clear_empty():
	if not _entity:
		return
	var new_array: Array[ItemEntity] = []
	for i in _entity.items.size():
		if _entity.items[i].is_empty(): continue
		new_array.append(_entity.items[i])
	return new_array
