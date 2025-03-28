class_name InventoryLocation
extends ContentContainer

@onready var _inventory_repository: InventoryRepository = Injector.inject(InventoryRepository, self)

@onready var _character_location: CharacterLocationState = Injector.inject(CharacterLocationState, self)
@onready var _inventory_character_state: InventoryCharacterState = Injector.inject(InventoryCharacterState, self) 
var _state := InventoryLocationState.new("Location")
@onready var world_object_repository: WorldObjectRepository = Injector.inject(WorldObjectRepository, self)
@onready var world_objects_layer_state: WorldObjectsLayerState = Injector.inject(WorldObjectsLayerState, self)
@onready var quantity_selector_state: QuantitySelectorState = Injector.inject(QuantitySelectorState, self)
@onready var inventory_repository: InventoryRepository = Injector.inject(InventoryRepository, self)
@onready var character_location_state: CharacterLocationState = Injector.inject(CharacterLocationState, self)

@onready var inventory: InventoryDisplay = %Inventory
@onready var location_panel: MarginContainer = %LocationPanel
@onready var item_information_panel: ItemInfoPanel = %ItemInformationPanel


func _enter_tree() -> void:
	Injector.provide(InventoryLocationState, _state, self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	_state.changed_inventory_entity.connect(inventory.update)
	_character_location.current_location_changed.connect(_on_location_changed)

	inventory.item_pressed.connect(item_information_panel.update)
	inventory.state = _state
	inventory.update(_state.inventory_entity)
	item_information_panel.set_bottom_actions([
		{
			"text": "KEY_BUTTON_PICKUP",
			"on_pressed": on_pick_up_item,
			"can_view": can_show_pick_up_button
		}
	])

func can_show_pick_up_button(item_entity: ItemEntity):
	return item_entity.get_resource().is_pickable

func on_pick_up_item(item: ItemEntity):
	quantity_selector_state.open(
		item.get_total_amount(),
		"Pick up",
		func(count: int): _on_confirmed_pick_up_item(item, count)
	)

func _on_confirmed_pick_up_item(item: ItemEntity, count: int):
	var all_used = item.get_used()
	var real_count = min(item.get_total_amount(), count)
	_state.remove_item(item.get_resource().code_name, count)
	var used = all_used.slice(0, min(all_used.size(), real_count))
	
	_inventory_character_state.add_item(item.get_resource(), real_count, used)

	var belong_at = _state.inventory_entity.belongs_at
	if _state.is_empty() and belong_at.type == InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION:
		var world_object = world_object_repository.get_by_id(belong_at.id)

		if world_object and world_object.resource.resource_path == 'res://resources/collection/world_object/location/camp.tres':
			world_object_repository.delete(belong_at.id)
			inventory_repository.delete(_state.inventory_entity.id)

			world_objects_layer_state.request_rerender()
			_state.inventory_entity = InventoryEntity.new()
			character_location_state.request_reload()

func _on_location_changed(location: Variant):
	location_panel._visual_randerer()
	if is_instance_of(location, WorldObjectEntity):
		var existed_inventory = _inventory_repository.get_by_belong_at_object(
			InventoryEntity.BelongsAtObject.new(
				location.id, InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
			)
		)

		if existed_inventory != null:
			_state.change_entity(existed_inventory)
		else:
			_state.change_entity(InventoryEntity.new(
				-1,
				InventoryEntity.BelongsAtObject.new(
					location.id, InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
				)
			))

		_state.search_drop = location.resource.search_drop
		return

	if is_instance_of(location, CharacterLocationState.BiomesLocation):
		_state.change_entity(InventoryEntity.new())
		_state.search_drop = SearchDropResource.merge(
			location.biomes.map(func(biome): return biome.search_drop)
		)
		return

	_state.search_drop = null
