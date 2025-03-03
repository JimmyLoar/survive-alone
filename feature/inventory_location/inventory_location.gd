class_name InventoryLocation
extends ContentContainer

@onready var _inventory_repository: InventoryRepository = Injector.inject(InventoryRepository, self)
@onready
var _character_location: CharacterLocationState = Injector.inject(CharacterLocationState, self)

var _state := InventoryLocationState.new("Location")

@onready var inventory: InventoryDisplay = %Inventory
@onready
var location_panel: MarginContainer = %LocationPanel
@onready
var item_information_panel: ItemInfoPanel = %ItemInformationPanel


func _enter_tree() -> void:
	Injector.provide(InventoryLocationState, _state, self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	_state.changed_inventory_entity.connect(inventory.update)
	_character_location.current_location_changed.connect(_on_location_changed)

	inventory.item_pressed.connect(item_information_panel.update)
	inventory.state = _state
	inventory.update(_state.inventory_entity)


func _on_location_changed(location: Variant):
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
