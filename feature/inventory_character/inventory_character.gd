extends ContentContainer



var _state := InventoryCharacterState.new("Character")

@onready var _inventory_repository: InventoryRepository = Injector.inject(InventoryRepository, self)
@onready var inventory: InventoryDisplay = %Inventory
@onready var item_information_panel: ItemInfoPanel = %ItemInformationPanel
@onready var quantity_selector_state: QuantitySelectorState = Injector.inject(QuantitySelectorState, self)
@onready var location_inventory_state: InventoryLocationState = Injector.inject(InventoryLocationState, self)


func _enter_tree() -> void:
	Injector.provide(InventoryCharacterState, _state, self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	Callable(func(): 
		_state.inventory_entity = _inventory_repository.get_by_player_id()
		).call_deferred()
		
	_state.changed_inventory_entity.connect(inventory.update)
	inventory.item_pressed.connect(item_information_panel.update)
	inventory.update(_state.inventory_entity)
	inventory.state = _state
	item_information_panel.set_bottom_actions([
		{
			"text": "Drop",
			"on_pressed": on_drop_item
		}
	])
	
func on_drop_item(item: ItemEntity):
	quantity_selector_state.open(
		item.get_total_amount(),
		"Drop",
		func(count: int): _on_confirmed_drop_item(item, count)
	)


func _on_confirmed_drop_item(item: ItemEntity, count: int):
	_state.remove_item(item.get_resource(), count)
	_inventory_repository.insert(_state.inventory_entity)
	
	# TODO: 
	#	1) Обновить location inventory
	#   2) Если мы в биоме создать world object для нового инвенторя
	# 	3) Сохранить location inventory и новый  world object
	#   4) Обновить character location
