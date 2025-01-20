class_name InventoryLocation
extends ContentContainer

@onready var _inventory_repository: InventoryRepository = Injector.inject(InventoryRepository, self)
@onready
var _character_location: CharacterLocationState = Injector.inject(CharacterLocationState, self)

var _state := InventoryLocationState.new("Location")

@onready var inventory: InventoryDisplay = $_MarginContainer/HBoxContainer/MainContainer/Inventory
@onready
var location_panel: MarginContainer = $_MarginContainer/HBoxContainer/SubContainer/LocationPanel
@onready
var item_information_panel: ItemInfoPanel = $_MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel


func _enter_tree() -> void:
	Injector.provide(InventoryLocationState, _state, self)


func _ready() -> void:
	_state._inventory_repository = _inventory_repository
	_state.changed_inventory_entity.connect(inventory.update)
	_character_location.current_location_changed.connect(_on_location_changed)

	inventory.item_pressed.connect(item_information_panel.update)
	inventory.update(_state.inventory_entity)


func _on_location_changed(location: Variant):
	if is_instance_of(location, WorldObjectEntity):
		#TODO найти сущ инвентарь WorldObjectEntity или создать пустой на его основе
		_state.change_entity(InventoryEntity.new())
		return

	if is_instance_of(location, CharacterLocationState.BiomesLocation):
		#TODO создать пустой инвентарь на основе BiomesLocation
		_state.change_entity(InventoryEntity.new())
		pass
