extends Panel

const WORLD_OBJECT_FOLDER_PATH = "res://common/world_objects/instances/"

@onready var _objects_list: ItemList = %ObjectsList
@onready var _search_input: TextEdit = %SearchInput
@onready var _inspector: Node = %Inspector
@onready var _state: GameEditor__StructuresToolState = Injector.inject(GameEditor__StructuresToolState, self)

func _ready() -> void:
	_state.world_objects_changed.connect(_on_world_objects_changed)
	reload_all_world_objects.call_deferred()

func reload_all_world_objects():
	var world_objects = [] as Array[Resource]
	var file_names = ResourceLoader.list_directory(WORLD_OBJECT_FOLDER_PATH)
	for file_name in file_names:
		var path = WORLD_OBJECT_FOLDER_PATH + file_name
		world_objects.append(ResourceLoader.load(path, "", ResourceLoader.CacheMode.CACHE_MODE_IGNORE_DEEP))
	
	_state.world_objects = world_objects

func _on_refresh_pressed() -> void:
	reload_all_world_objects()

func _on_world_objects_changed(__: Array[Resource]):
	rerender_list()

func rerender_list():
	_objects_list.clear()
	_objects_list.deselect_all()

	var index_to_select = -1
	for i in range(0, _state.visible_world_objects.size()):
		var object = _state.visible_world_objects[i]
		var file_name = object.resource_path.get_file().trim_suffix(".tscn")

		_objects_list.add_item(file_name)

		if (_state.selected_object_uid == ResourceLoader.get_resource_uid(object.resource_path)):
			index_to_select = i

	if index_to_select >= 0:
		_objects_list.select(index_to_select)
		_inspector.show()
	else:
		_objects_list.deselect_all()
		_inspector.hide()

func _on_objects_list_item_selected(index: int) -> void:
	if index < 0:
		_state.selected_object_uid = GameEditor__StructuresToolState.UNSELECTED_OBJECT_UID
		_inspector.hide()
	else:
		var object = _state.visible_world_objects[index]
		_state.selected_object_uid = ResourceLoader.get_resource_uid(object.resource_path)
		_inspector.show()


func _on_apply_search_pressed() -> void:
	var clean_query = _search_input.text.trim_prefix(" ")
	clean_query = clean_query.trim_suffix(" ")
	_state.search_query = clean_query
	rerender_list()
	
