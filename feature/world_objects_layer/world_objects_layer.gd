class_name WorldObjectsLayer
extends Node2D


@export var show_collision_shapes: bool
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16)
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  

var _state: WorldObjectsLayerState
var _visible_object_nodes = Dictionary()

@onready var _virtual_chunks_state: VirtualChunksState = Locator.get_service(VirtualChunksState)


func _enter_tree() -> void:
	_state = Locator.initialize_service(WorldObjectsLayerState)
	_state._host_node = self

func _ready() -> void:
	_virtual_chunks_state.visible_chunks_rect_changed.connect(_on_virtual_chunks_rect_changed)
	_state.visible_objects_changed.connect(_on_visible_objects_changed)
	

func _on_virtual_chunks_rect_changed(rect: Rect2i):
	var chunk_size_in_pixels = chunk_size * tile_size
	_state.set_visible_rect(Rect2(rect.position * chunk_size_in_pixels, rect.size * chunk_size_in_pixels))


func _on_visible_objects_changed(diff: WorldObjectsLayerState.VisibleObjectsDiff, _value: Dictionary):
	for object_id in diff.removed:
		_remove_visible_object_node(object_id)
	for object_id in diff.added:
		_add_visible_object_node(object_id)


func _remove_visible_object_node(object_id: int):
	if _visible_object_nodes.has(object_id):
		remove_child(_visible_object_nodes[object_id])
		_visible_object_nodes.erase(object_id)


func _add_visible_object_node(object_id: int):
	if not _visible_object_nodes.has(object_id):
		var node = _load_object_node(_state.visible_objects[object_id])
		add_child(node)
		_visible_object_nodes[object_id] = node


func _load_object_node(entity: WorldObjectEntity):
	var node = entity.packed_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	node.position = entity.get_offset()
	node.show_collision_shape = show_collision_shapes
	node.world_object_id = entity.id
	return node

func reset():
	for child in get_children():
		remove_child(child)
	_visible_object_nodes.clear()
