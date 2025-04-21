class_name CharacterLocation
extends Node

@onready var _character_state: CharacterState = Locator.get_service(CharacterState)
@onready var _biomes_layer_state: BiomesLayerState = Locator.get_service(BiomesLayerState)
@onready var _world_objects_layer_state: WorldObjectsLayerState = Locator.get_service(WorldObjectsLayerState)

var _state: CharacterLocationState


func _enter_tree() -> void:
	_state = Locator.initialize_service(CharacterLocationState, [self])


func _ready() -> void:
	_character_state.position_changed.connect(_on_character_position_changed)
	
	Callable(func():
		_on_character_position_changed(_character_state.position)
	).call_deferred()


func _on_character_position_changed(pos: Vector2):
	var world_object = _world_objects_layer_state.get_object_by_position_fast(pos)

	if world_object != null:
		if (
			not is_instance_of(_state.current_location, WorldObjectEntity)
			or _state.current_location.id != world_object.id
		):
			_state.current_location = world_object
		return

	var tile_pos = _biomes_layer_state.global_to_map(pos)

	if not is_instance_of(_state.current_location, CharacterLocationState.BiomesLocation):
		var biomes = _biomes_layer_state.get_visible_tile_biomes_fast(tile_pos)
		_state.current_location = CharacterLocationState.BiomesLocation.new(tile_pos, biomes)
		return
	if tile_pos != _state.current_location._tile_pos:
		var biomes = _biomes_layer_state.get_visible_tile_biomes_fast(tile_pos)
		var new_location = CharacterLocationState.BiomesLocation.new(tile_pos, biomes)

		if not _state.current_location.is_equal_biomes(new_location):
			_state.current_location = new_location
			return

func reload():
	_on_character_position_changed(_character_state.position)
