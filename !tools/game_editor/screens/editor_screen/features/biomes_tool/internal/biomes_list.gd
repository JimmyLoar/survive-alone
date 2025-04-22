extends Control

@onready var _inspector: Control = %Inspector
@onready var _biomes_list: ItemList = %BiomesList
@onready var _id_label: Label = %IdLabel
@onready var _name_input: TextEdit = %NameInput
@onready var _resource_button: Button = %ResourceButton
@onready var _choose_resource_dialog: FileDialog = %ChooseResourceDialog

@onready var _state: GameEditor__BiomesToolState = Locator.get_service(GameEditor__BiomesToolState)
@onready var _biomes_layer: BiomesLayerState = Locator.get_service(BiomesLayerState)

func _ready() -> void:
	_state.biomes_changed.connect(_biomes_list_changed)
	_state.selected_biome_id_changed.connect(_selected_biome_id_changed)

func _biomes_list_changed(biomes: Array[BiomeEntity]):
	_biomes_list.clear()
	_biomes_list.deselect_all()

	var index_to_select = -1
	for i in range(0, biomes.size()):
		var biome: BiomeEntity = biomes[i]
		_biomes_list.add_item("%d: %s" %[biome.id, biome.name])
		if (_state.selected_biome_id == biome.id):
			index_to_select = i

	if index_to_select >= 0:
		_biomes_list.select(index_to_select)
		_inspector.show()
	else:
		_biomes_list.deselect_all()
		_inspector.hide()

func _selected_biome_id_changed(id: int):
	_biomes_list.deselect_all()
	if id == null:
		_inspector.hide()
		return

	var index = Utils.find_index(_state.biomes, func(biome): return biome.id == id)

	if index < 0:
		_inspector.hide()
		return
		
	_biomes_list.select(index)

	var biome = _state.biomes[index]
	_id_label.text = "%d" % biome.id
	_name_input.text = biome.name
	_resource_button.text = biome.resource.resource_path.get_file()
	
	_inspector.show()


func _on_name_input_text_changed() -> void:
	var index = Utils.find_index(_state.biomes, func(biome): return biome.id == _state.selected_biome_id)
	var biome: BiomeEntity = _state.biomes[index]
	
	biome.name = _name_input.text
	
	_state.update_selected_biome(biome)


func _on_biomes_list_item_selected(index: int) -> void:
	var biome = _state.biomes[index]
	_state.selected_biome_id = biome.id

func _on_create_biome_pressed() -> void:
	_state.create_biome()

func _on_remove_biome_pressed() -> void:
	_state.remove_selected_biome()


func _on_resource_button_pressed() -> void:
	_choose_resource_dialog.show()



func _on_choose_resource_dialog_file_selected(path: String) -> void:
	var resource: BiomeResource = load(path)
	
	var index = Utils.find_index(_state.biomes, func(biome): return biome.id == _state.selected_biome_id)
	var biome: BiomeEntity = _state.biomes[index]
	
	biome.resource = resource
	_state.update_selected_biome(biome)
	_resource_button.text = biome.resource.resource_path.get_file()
	_biomes_layer.refresh_visible_biome(biome.id)


func _on_refresh_resource_pressed() -> void:
	var index = Utils.find_index(_state.biomes, func(biome): return biome.id == _state.selected_biome_id)
	var biome: BiomeEntity = _state.biomes[index]
	var path = biome.resource.resource_path
	var resource: BiomeResource = load(path)
	
	biome.resource = resource
	_state.update_selected_biome(biome)
	_resource_button.text = biome.resource.resource_path.get_file()
	_biomes_layer.refresh_visible_biome(biome.id)
