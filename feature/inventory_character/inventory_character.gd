class_name InventoryCharacter
extends InventoryBase

@export var up_buttons: HButtonsContainer


#
#
#var _state := InventoryCharacterState.new("Character")
#
#@onready var inventory: InventoryPageDisplay = %Inventory
#@onready var item_information_panel: ItemInfoPanel = %ItemInformationPanel
#@onready var quantity_selector_state: QuantitySelectorState = Locator.get_service(QuantitySelectorState)
#@onready var location_inventory_state: InventoryLocationState = Locator.get_service(InventoryLocationState)
#@onready var character_location_state: CharacterLocationState = Locator.get_service(CharacterLocationState)
#@onready var character_state: CharacterState = Locator.get_service(CharacterState)
#@onready var world_object_repository: WorldObjectRepository = Locator.get_service(WorldObjectRepository)
#@onready var world_objects_layer_state: WorldObjectsLayerState = Locator.get_service(WorldObjectsLayerState)
#
#

func _enter_tree() -> void:
	Locator.add_initialized_service(self)
#

func _ready() -> void:
	super()
	_inventory.change_entity.call_deferred(_inventory_repository.get_by_player_id())
	inventory_display.item_pressed.connect(item_information.update)
	item_information.set_bottom_actions([
		{
			"text": "KEY_BUTTON_DROP",
			"on_pressed": on_drop_item,
			"can_view": func(_item: ItemEntity): return true
		}
	])
	print("InventoryCharacter ready!")
	up_buttons.create_buttons([
		up_buttons.create_currect_dictionary(
			(func(): _inventory._entity.items.sort()), "sort"
		)
	])


func open():
	if self.visible:
		close()
		return
	
	self.show()


func close():
	self.hide()


func on_drop_item(item: ItemEntity):
	pass
	#quantity_selector_state.open(
		#item.get_storage().get_amount(),
		#"Drop",
		#func(count: int): _on_confirmed_drop_item(item, count)
	#)
#
#



#func _on_confirmed_drop_item(item: ItemEntity, count: int):
	#var removed_items = item.get_storage().remove(count)
	#location_inventory_state.add_item(item.get_resource_uid(), removed_items)
	#
	#var current_location = character_location_state.current_location
	#if is_instance_of(current_location, CharacterLocationState.BiomesLocation):
		#var world_object = WorldObjectEntity.new()
		#world_object.resource = load("res://resources/collection/world_object/location/camp.tres")
		#var boundary_rect = world_object.resource.collision_shape.get_rect()
		#boundary_rect.position += character_state.position
		#world_object.boundary_rect = boundary_rect
#
		#var world_object_id = world_object_repository.create(world_object, false)
#
		#location_inventory_state.inventory_entity.belongs_at = InventoryEntity.BelongsAtObject.new(
			#world_object_id,
			#InventoryEntity.BelongsAtObject.Type.WORLD_LOCATION
		#)
	#_inventory_repository.insert(_state.inventory_entity)
	#_inventory_repository.insert(location_inventory_state.inventory_entity)
#
	#if is_instance_of(current_location, CharacterLocationState.BiomesLocation):
		#world_objects_layer_state.request_rerender()
		#character_location_state.current_location = world_object_repository.get_by_id(location_inventory_state.inventory_entity.belongs_at.id)
	#else:
		## request rerender location inventory
		#location_inventory_state.change_entity(location_inventory_state.inventory_entity)
