class_name InventoryLocation
extends ContentContainer

var _inventory_repository: InventoryRepository
var _state := InventoryLocationState.new("Location")


@onready var inventory: InventoryDisplay = $_MarginContainer/HBoxContainer/MainContainer/Inventory
@onready var location_panel: MarginContainer = $_MarginContainer/HBoxContainer/SubContainer/LocationPanel
@onready var item_information_panel: ItemInfoPanel = $_MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel


func _enter_tree() -> void:
	Injector.provide(InventoryLocationState, _state, self)


func _ready() -> void:
	_inventory_repository = Injector.inject(InventoryRepository, self)
	_state._inventory_repository = _inventory_repository
	Callable(func(): 
		_state.inventory_entity = _inventory_repository.get_by_temp_id()
		_state.add_item(load("res://resources/collection/items/resource/wood.tres"), 8)
		).call_deferred()
	
	_state.changed_inventory_entity.connect(inventory.update)
	inventory.item_pressed.connect(item_information_panel.update)
	inventory.update(_state.inventory_entity)
