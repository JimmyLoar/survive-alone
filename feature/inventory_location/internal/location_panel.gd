extends MarginContainer

@onready var name_label: Label = %NameLabel
@onready var search_display: MarginContainer = %SearchDisplay
@onready
var search_button: Button = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Search

@onready var _inventory_location_state: InventoryLocationState = Injector.inject(
	InventoryLocationState, self
)


func _ready() -> void:
	_inventory_location_state.search_drop_changed.connect(_on_search_drop_changed)

	Callable(func(): _rerender())


func _on_search_drop_changed(search_drop: SearchDropResource):
	_rerender()


func _rerender():
	if (
		_inventory_location_state.search_drop == null
		or _inventory_location_state.search_drop.items_count == 0
	):
		search_button.disabled = true
	else:
		search_button.disabled = false

	search_display.update(_inventory_location_state.search_drop)


func _on_search_pressed() -> void:
	var searcher := Searcher.new()
	search_button.hide()
	search_display.start_search(searcher.search(_inventory_location_state.search_drop))
