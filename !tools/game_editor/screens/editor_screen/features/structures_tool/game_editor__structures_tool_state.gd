class_name GameEditor__StructuresToolState
extends Injectable

var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)
var _host_node: Node

func _init(node: Node):
	_host_node = node

signal world_objects_changed(value: Array[Resource])
var world_objects: Array[Resource]:
	set(value):
		world_objects = value
		world_objects_changed.emit(value)

signal search_query_changed(value: String)
var search_query: String = "":
	set(value):
		search_query = value
		search_query_changed.emit(value)


var visible_world_objects: Array[Resource]:
	get:
		if search_query == "":
			return world_objects
		return world_objects.filter(func(world_object: Resource): return world_object.resource_path.get_file().contains(search_query))

const UNSELECTED_OBJECT_UID = -2
var selected_object_uid: int = UNSELECTED_OBJECT_UID

class PlaceObjectMode:
	var scene: PackedScene

class EditObjectMode:
	var object: WorldObjectEntity

signal mode_changed(value: Variant)
var mode: Variant = null:
	set(value):
		mode = value
		mode_changed.emit(value)
		
func place_object():
	var _screen_state: GameEditor__EditorScreenState = Injector.inject(GameEditor__EditorScreenState, _host_node)
	var _world_object_repository: WorldObjectRepository = Injector.inject(WorldObjectRepository, _host_node)
	var _world_object_layer: WorldObjectsLayerState = Injector.inject(WorldObjectsLayerState, _host_node)
	
	var tile_pos = _screen_state.hovered_biome_tile_pos
	
	if tile_pos == _screen_state.UNHOVERED_BIOME_TILE_POS:
		mode = null
		return
	
	var scene_node: BaseWorldObject = mode.scene.instantiate()
	var entity = WorldObjectEntity.new()

	entity.boundary_rect = scene_node.get_collision_shape().get_rect()
	entity.boundary_rect.position += Vector2(tile_pos.x * tile_size, tile_pos.y * tile_size)
	entity.packed_scene = mode.scene
	
	_world_object_repository.create(entity, true)
	_world_object_layer.request_rerender()
	
func move_object():
	var _screen_state: GameEditor__EditorScreenState = Injector.inject(GameEditor__EditorScreenState, _host_node)
	var _world_object_repository: WorldObjectRepository = Injector.inject(WorldObjectRepository, _host_node)
	var _world_object_layer: WorldObjectsLayerState = Injector.inject(WorldObjectsLayerState, _host_node)
	
	var tile_pos = _screen_state.hovered_biome_tile_pos
	
	if not is_instance_of(mode, EditObjectMode) or tile_pos == _screen_state.UNHOVERED_BIOME_TILE_POS:
		return

	mode.object.boundary_rect = mode.object._get_node().get_collision_shape().get_rect()
	mode.object.boundary_rect.position += Vector2(tile_pos.x * tile_size, tile_pos.y * tile_size)

	_world_object_repository.update(mode.object)
	_world_object_layer.request_rerender()

func remove_object():
	if not is_instance_of(mode, EditObjectMode):
		return
	var _world_object_repository: WorldObjectRepository = Injector.inject(WorldObjectRepository, _host_node)
	var _world_object_layer: WorldObjectsLayerState = Injector.inject(WorldObjectsLayerState, _host_node)
	
	_world_object_repository.delete(mode.object.id)
	_world_object_layer.request_rerender()
