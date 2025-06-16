class_name InventoryBase
extends PanelContainer


@export var inventory_display : InventoryPageDisplay
@export var item_information : ItemInformation

@onready var _inventory_repository: InventoryRepository = Locator.get_service(InventoryRepository)

var _inventory := Inventory.new()


func _ready() -> void:
	_inventory.changed_inventory_entity.connect(inventory_display.set_entity)

	
