extends ContentContainer



var _state := InventoryCharacterState.new("Character")

@onready var _inventory_repository: InventoryRepository = Locator.get_service(InventoryRepository)
@onready var inventory: InventoryDisplay = %Inventory
@onready var item_information_panel: ItemInfoPanel = %ItemInformationPanel
@onready var quantity_selector_state: QuantitySelectorState = Locator.get_service(QuantitySelectorState)
@onready var location_inventory_state: InventoryLocationState = Locator.get_service(InventoryLocationState)
@onready var character_location_state: CharacterLocationState = Locator.get_service(CharacterLocationState)
@onready var character_state: CharacterState = Locator.get_service(CharacterState)
@onready var world_object_repository: WorldObjectRepository = Locator.get_service(WorldObjectRepository)
@onready var world_objects_layer_state: WorldObjectsLayerState = Locator.get_service(WorldObjectsLayerState)


func _enter_tree() -> void:
	Locator.add_initialized_service(_state)


func _ready() -> void:
	Callable(func(): 
		_state.inventory_entity = _inventory_repository.get_by_player_id()
		).call_deferred()
		
	_state.changed_inventory_entity.connect(inventory.update)
	inventory.item_pressed.connect(item_information_panel.update)
	inventory.update(_state.inventory_entity)
	inventory.state = _state
	item_information_panel.set_bottom_actions([
		{
			"text": "KEY_BUTTON_DROP",
			"on_pressed": on_drop_item,
			"can_view": func(item: ItemEntity): return true
		}
	])
	
func on_drop_item(item: ItemEntity):
	quantity_selector_state.open(
		item.get_total_amount(),
		"Drop",
		func(count: int): _on_confirmed_drop_item(item, count)
	)


func _on_confirmed_drop_item(item: ItemEntity, count: int):
	var all_used = item.get_used()
	var real_drop_count = min(item.get_total_amount(), count)
	_state.remove_item(item.get_resource().code_name, count)
	var used = all_used.slice(0, min(all_used.size(), real_drop_count))
	
	location_inventory_state.add_item(item.get_resource(), real_drop_count, used)
	
	var current_location = character_location_state.current_location
	if is_instance_of(current_location, CharacterLocationState.BiomesLocation):
		var world_object = WorldObjectEntity.new()
		world_object.resource = load("res://resources/collection/world_object/location/camp.tres")
		var boundary_rect = world_object.resource.collision_shape.get_rect()
		boundary_rect.position += character_state.position
		world_object.boundary_rect = boundary_rect

		var world_object_id = world_object_repository.create(world_object, false)

		location_inventory_state.inventory_entity.belongs_at = InventoryEntity.BelongsAtObject.new(
			world_object_id,
			InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
		)
	_inventory_repository.insert(_state.inventory_entity)
	_inventory_repository.insert(location_inventory_state.inventory_entity)

	if is_instance_of(current_location, CharacterLocationState.BiomesLocation):
		world_objects_layer_state.request_rerender()
		character_location_state.current_location = world_object_repository.get_by_id(location_inventory_state.inventory_entity.belongs_at.id)
	else:
		# request rerender location inventory
		location_inventory_state.change_entity(location_inventory_state.inventory_entity)
