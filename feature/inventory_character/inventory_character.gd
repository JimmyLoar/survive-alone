class_name InventoryCharacter
extends Inventory


signal item_removed(item_name: String)
signal item_added(item_name: String)


@export var up_buttons: HButtonsContainer

@onready var quantity_selector_state: QuantitySelectorState = Locator.get_service(QuantitySelectorState)
@onready var inventory_location: InventoryLocation = Locator.get_service(InventoryLocation)
@onready var character_location_state: CharacterLocationState = Locator.get_service(CharacterLocationState)
@onready var character_state: CharacterState = Locator.get_service(CharacterState)
@onready var world_object_repository: WorldObjectRepository = Locator.get_service(WorldObjectRepository)
@onready var world_objects_layer_state: WorldObjectsLayerState = Locator.get_service(WorldObjectsLayerState)

@onready var tab_container: TabContainer = $SpliteContainer/TabContainer



func _init() -> void:
	super("InventoryCharacter")


func _enter_tree() -> void:
	Locator.add_initialized_service(self)
#

func _ready() -> void:
	super()
	character_location_state.current_location_changed.connect(change_entity)
	change_entity.call_deferred(_inventory_repository.get_by_player_id())
	inventory_display.item_pressed.connect(item_information.update)
	item_information.set_bottom_actions([
		{
			"text": "KEY_BUTTON_DROP",
			"on_pressed": on_drop_item,
			"can_view": func(_item: ItemEntity): return true
		}
	])
	up_buttons.create_buttons([
		up_buttons.create_currect_dictionary(
			(func(): _entity.items.sort()), 
			"sort",
		)
	])


func open():
	if self.visible:
		close()
		return
	
	inventory_display.update()
	self.show()


func close():
	self.hide()


func remove_item(_name: String, _amount := 1):
	var res = super(_name, _amount)
	item_removed.emit(name)
	return res


func add_item(uid: String, value: Variant = 0) -> ItemEntity:
	var res = super(uid, value) as ItemEntity
	item_added.emit(load(uid).code_name)
	return res


func on_drop_item(item: ItemEntity):
	quantity_selector_state.open(
		item.get_storage().get_amount(),
		"Drop",
		func(count: int): _on_confirmed_drop_item(item, count)
	)


func _on_confirmed_drop_item(item: ItemEntity, count: int):
	var removed_items = item.get_storage().remove(count)

	
	# create camp location
	var current_location = character_location_state.current_location
	if is_instance_of(current_location, CharacterLocationState.BiomesLocation):
		var world_object = WorldObjectEntity.new()
		world_object.packed_scene = load("res://common/world_objects/instances/camp_location.tscn")
		var boundary_rect = world_object.get_collision_shape_in_global_coords().get_rect()
		boundary_rect.position += character_state.position
		world_object.boundary_rect = boundary_rect
		
		var world_object_id = world_object_repository.create(world_object, false)
		
		var camp_location_entity = InventoryEntity.new(
			-1,
			InventoryEntity.BelongsAtObject.new(
				world_object_id, 
				InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
			),
			[ItemEntity.new(item.get_resource_uid(), removed_items)]
		)

		inventory_location.change_entity(camp_location_entity)
	else:
		inventory_location.add_item(item.get_resource_uid(), removed_items)
	
	# save inventories
	_inventory_repository.insert(_entity)
	_inventory_repository.insert(inventory_location.get_entity())
	
	if is_instance_of(current_location, CharacterLocationState.BiomesLocation):
		world_objects_layer_state.request_rerender()
		character_location_state.current_location = world_object_repository.get_by_id(inventory_location.get_entity().belongs_at.id)
	else:
		# request rerender location inventory
		inventory_location.inventory_display.update()


func _on_close_pressed() -> void:
	if tab_container.current_tab <= 0:
		self.close()
	else:
		tab_container.current_tab = 0
