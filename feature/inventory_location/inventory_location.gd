class_name InventoryLocation
extends ContentContainer

var _inventory_repository: InventoryRepository
var _state := InventoryLocationState.new()


func _enter_tree() -> void:
	Injector.provide(InventoryLocationState, _state, self)


func _ready() -> void:
	_inventory_repository = Injector.inject(InventoryRepository, self)
	_state._inventory_repository = _inventory_repository
	Callable(func(): 
		_state.inventory = _inventory_repository.get_by_player_id()
		).call_deferred()
