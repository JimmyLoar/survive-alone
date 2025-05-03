extends MarginContainer

@onready var name_label: Label = %NameLabel
@onready var search_display: MarginContainer = %SearchDisplay
@onready
var search_button: Button = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Search
@onready var discription_label: RichTextLabel = %DiscriptionLabel

@onready var _inventory_location_state: InventoryLocationState = Locator.get_service(InventoryLocationState)
@onready var _event_state: EventState = Locator.get_service(EventState)
@onready var _location: CharacterLocationState = Locator.get_service(CharacterLocationState)


func _ready() -> void:
	_inventory_location_state.search_drop_changed.connect(_on_search_drop_changed)

	Callable(func(): 
		_visual_randerer()
		_rerender()
	)


func _visual_randerer():
	name_label.text = _location.get_location_name()
	discription_label.clear()
	discription_label.append_text(_location.get_location_discription())
	


func _on_search_drop_changed(_search_drop: SearchDropResource):
	_rerender()


func _rerender():
	if is_instance_of(_location.current_location, WorldObjectEntity):
		if (
			_inventory_location_state.search_drop == null
			or _inventory_location_state.search_drop.items_count == 0
		):
			search_button.hide()
		else:
			search_button.show()
	else:
		search_button.show()
	search_display.update(_inventory_location_state.search_drop)


func _on_search_pressed() -> void:
	if is_instance_of(_location.current_location, WorldObjectEntity):
		var searcher := Searcher.new()
		search_button.hide()
		search_display.start_search(searcher.search(_inventory_location_state.search_drop))
	elif is_instance_of(_location.current_location, CharacterLocationState.BiomesLocation):
		_event_state.start_event(preload("res://resources/collection/events/biome_search/bs_defualt_event.tres").instantiate())
	
	else:
		print_debug("location none")
		#breakpoint
		
