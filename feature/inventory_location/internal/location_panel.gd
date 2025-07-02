extends MarginContainer

@onready var name_label: Label = %NameLabel
@onready var search_display: MarginContainer = %SearchDisplay
@onready
var search_button: Button = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Search
@onready var discription_label: RichTextLabel = %DiscriptionLabel

@onready var _inventory_location: InventoryLocation = Locator.get_service(InventoryLocation)
@onready var _event_state: EventState = Locator.get_service(EventState)
@onready var _location: CharacterLocationState = Locator.get_service(CharacterLocationState)


func _ready() -> void:
	_inventory_location.search_drop_changed.connect(_on_search_drop_changed)
	
	# Делаем заголовок кликабельным для переключения на вкладку с предметами
	name_label.mouse_filter = Control.MOUSE_FILTER_STOP
	name_label.gui_input.connect(_on_name_label_gui_input)

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
			_inventory_location.search_drop == null
			or _inventory_location.search_drop.items_count == 0
		):
			search_button.hide()
		else:
			search_button.show()
	else:
		search_button.show()
	search_display.update(_inventory_location.search_drop)


func _on_name_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Переключаемся на вкладку с предметами
		_inventory_location.tab_container.current_tab = 1


func _on_search_pressed() -> void:
	if is_instance_of(_location.current_location, WorldObjectEntity):
		var searcher := Searcher.new()
		search_button.hide()
		search_display.start_search(searcher.search(_inventory_location.search_drop))
	elif is_instance_of(_location.current_location, CharacterLocationState.BiomesLocation):
		_event_state.start_event(preload("res://resources/collection/events/biome_search/bs_defualt_event.tres").instantiate())
	
	else:
		print_debug("location none")
		#breakpoint
		
