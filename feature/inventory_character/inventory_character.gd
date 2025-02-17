extends ContentContainer



var _state := InventoryCharacterState.new("Character")

@onready var _inventory_repository: InventoryRepository = Injector.inject(InventoryRepository, self)
@onready var inventory: InventoryDisplay = %Inventory
@onready var item_information_panel: ItemInfoPanel = %ItemInformationPanel



func _enter_tree() -> void:
	Injector.provide(InventoryCharacterState, _state, self, "closest")


func _ready() -> void:
	Callable(func(): 
		_state.inventory_entity = _inventory_repository.get_by_player_id()
		).call_deferred()
		
	_state.changed_inventory_entity.connect(inventory.update)
	inventory.item_pressed.connect(item_information_panel.update)
	inventory.update(_state.inventory_entity)
	inventory.state = _state
