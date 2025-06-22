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
	
	assert(inventory_display && item_information, "Please, select 'Inventory Display' and 'Item Information' in inspector!")
	_logger.debug("Ready!")


func change_entity(_new_entity: InventoryEntity) -> InventoryEntity:
	_disconnect_all_items(_entity)
	var tmp = _entity
	_entity = _new_entity
	_connect_all_items(_entity)
	changed_entity.emit(_entity)
	return tmp


func _connect_all_items(entity: InventoryEntity):
	if not entity:
		return
	
	for item: ItemEntity in entity.items:
		var _signal = item.get_storage().quantity_changed
		if _signal.is_connected(_on_changed_value):
			continue
		_signal.connect(_on_changed_value.bind(item.get_resource().code_name)) 


func _disconnect_all_items(entity: InventoryEntity):
	if not entity:
		return
	
	for item: ItemEntity in entity.items:
		var _signal = item.get_storage().quantity_changed
		if not _signal.is_connected(_on_changed_value):
			continue
		_signal.disconnect(_on_changed_value.bind(item.get_resource().code_name)) 


func get_entity() -> InventoryEntity:
	var new_entity := _entity.duplicate() as InventoryEntity
	new_entity.items.make_read_only()
	new_entity.belongs_at = _entity.belongs_at
	return new_entity


func is_empty() -> bool:
	return _entity.items.is_empty()


func add_item(uid: String, value: Variant = 0) -> ItemEntity:
	var item = get_or_create_item(uid)
	item.get_storage().append(value)
	_logger.debug("Added [color=green]%d[/color] items [color=green]%s[/color]" % 
		[value, load(uid).code_name])
	changed_entity.emit(_entity)
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
	changed_entity.emit(_entity)
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
		return _add_in_storage_entity(ItemEntity.new(uid, 0))
	return get_item(index)


func get_inventory_size() -> int: 
	if not _entity: 
		return 0
	return _entity.items.size()


func get_items() -> Array[ItemEntity]: 
	if not _entity: 
		return []
	return _entity.items.duplicate()


func clear_empty(entity: InventoryEntity = _entity):
	if not entity:
		return
	
	var new_array: Array[ItemEntity] = []
	for i in entity.items.size():
		if entity.items[i].is_empty(): continue
		new_array.append(entity.items[i])
	
	_entity.items = new_array
	return new_array


func _add_in_storage_entity(item: ItemEntity) -> ItemEntity:
	var _index: int = _entity.items.size()
	if _entity and _entity.items.is_read_only():
		_entity.items = Array(_entity.items)
	_entity.items.append(item)
	_stored_cache[item.get_resource().code_name] = _index
	item.get_storage().quantity_changed.connect(_on_changed_value.bind(item.get_resource().code_name))
	changed_entity.emit.call_deferred(_entity)
	return item


func _remove_from_storage_entity(index: int) -> ItemEntity:
	if is_index_validate(index):
		var item: ItemEntity = _entity.items.pop_at(index)
		_stored_cache.erase(item.get_resource().code_name)
		changed_entity.emit.call_deferred(_entity)
		item.get_storage().quantity_changed.disconnect(_on_changed_value.bind(item.get_resource().code_name))
		return item
	return null


func _on_changed_value(value: int, index: String):
	if value <= 0:
		_remove_from_storage_entity(find_item(index))
	clear_empty(_entity)


func _on_request_to_delete(entity: ItemEntity):
	if entity.is_empty():
		_entity.items.erase(_entity)


func _recount_index_items(entity: InventoryEntity):
	clear_empty(entity)
	for i in entity.items.size():
		_stored_cache[entity.items[i].get_resource().code_name] = i
		
