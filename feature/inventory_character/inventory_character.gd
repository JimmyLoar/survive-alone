extends ContentContainer


var _inventory_repository: InventoryRepository
var _state := InventoryCharacterState.new("Character")


@onready var inventory: InventoryDisplay = $_MarginContainer/HBoxContainer/MainContainer/Inventory
@onready var item_information_panel: ItemInfoPanel = $_MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel



func _enter_tree() -> void:
	Injector.provide(InventoryCharacterState, _state, self)


func _ready() -> void:
	_inventory_repository = Injector.inject(InventoryRepository, self)
	_state._inventory_repository = _inventory_repository
	Callable(func(): 
		_state.inventory_entity = _inventory_repository.get_by_player_id()
		_test_inventory()
		).call_deferred()
	inventory.set_inventory(_state)


func _test_inventory():
	_state.add_item(load("res://resources/collection/items/food/fry_meat.tres"), 10)
	_state.add_item(load("res://resources/collection/items/food/canned_food.tres"), 5)
	_state.add_item(load("res://resources/collection/items/food/water_clear.tres"), 25)
	
