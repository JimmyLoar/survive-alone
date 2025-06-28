class_name InventoryLocation
extends Inventory

signal search_drop_changed(value: SearchDropResource)
var search_drop: SearchDropResource = null:
	get:
		return search_drop
	set(value):
		search_drop = value
		search_drop_changed.emit(value)


@onready var _character_location: CharacterLocationState = Locator.get_service(CharacterLocationState)
@onready var _inventory_character: InventoryCharacter = Locator.get_service(InventoryCharacter) 
@onready var world_object_repository: WorldObjectRepository = Locator.get_service(WorldObjectRepository)
@onready var world_objects_layer_state: WorldObjectsLayerState = Locator.get_service(WorldObjectsLayerState)
@onready var quantity_selector_state: QuantitySelectorState = Locator.get_service(QuantitySelectorState)
@onready var inventory_repository: InventoryRepository = Locator.get_service(InventoryRepository)
@onready var character_location_state: CharacterLocationState = Locator.get_service(CharacterLocationState)

@onready var location_panel: MarginContainer = %LocationPanel

@onready var tab_container: TabContainer = $SpliteContainer/TabContainer


func _init() -> void:
	super("InventoryLocation")


func _enter_tree() -> void:
	Locator.add_initialized_service(self)



func _ready() -> void:
	super()
	_character_location.current_location_changed.connect(_on_location_changed)
	_on_location_changed.call_deferred(_character_location.current_location)
	inventory_display.item_pressed.connect(item_information.update)
	inventory_display.set_entity(_entity)
	item_information.set_bottom_actions([
		{
			"text": "KEY_BUTTON_PICKUP",
			"on_pressed": on_pick_up_item,
			"can_view": can_show_pick_up_button
		}
	])


func open():
	if self.visible:
		close()
		return
	
	inventory_display.update()
	self.show()


func close():
	self.hide()


func can_show_pick_up_button(item_entity: ItemEntity):
	return item_entity.get_resource().is_pickable


func on_pick_up_item(item: ItemEntity):
	quantity_selector_state.open(
		item.get_storage().get_amount(),
		"Pick up",
		func(count: int): _on_confirmed_pick_up_item(item, count)
	)

func _on_confirmed_pick_up_item(entity: ItemEntity, count: int):
	var inventory_character = Locator.get_service(InventoryCharacter)
	var available_count = find_and_get_amount(entity.get_resource().code_name)
	var count_to_remove = count if available_count >= count else available_count;

	remove_item(entity.get_resource().code_name, count_to_remove)

	inventory_character.add_item(entity.get_resource_uid(), count_to_remove)
	_inventory_repository.insert(inventory_character.get_entity())

	var belong_at = _entity.belongs_at
	if is_empty() and belong_at.type == InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION:
		var world_object = world_object_repository.get_by_id(belong_at.id)

		if world_object and world_object.packed_scene.resource_path == 'res://common/world_objects/instances/camp_location.tscn':
			world_object_repository.delete(belong_at.id)
			inventory_repository.delete(_entity.id)

			world_objects_layer_state.request_rerender()
			change_entity(InventoryEntity.new())
			character_location_state.request_reload()
	else:
		inventory_repository.insert(_entity)


func _on_location_changed(location: Variant):
	location_panel._visual_randerer()
	if is_instance_of(location, WorldObjectEntity):
		var existed_inventory = _inventory_repository.get_by_belong_at_object(
			InventoryEntity.BelongsAtObject.new(
				location.id, InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
			)
		)

		if existed_inventory != null:
			change_entity(existed_inventory)
		else:
			change_entity(InventoryEntity.new(
				-1,
				InventoryEntity.BelongsAtObject.new(
					location.id, InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
				)
			))

		search_drop = location._get_node().search_drop
		return

	if is_instance_of(location, CharacterLocationState.BiomesLocation):
		change_entity(InventoryEntity.new())
		search_drop = SearchDropResource.merge(
			location.biomes.map(func(biome): return biome.resource.search_drop)
		)
		return

	search_drop = null


func _on_close_pressed() -> void:
	if tab_container.current_tab <= 0:
		self.close()
	else:
		tab_container.current_tab = 0
