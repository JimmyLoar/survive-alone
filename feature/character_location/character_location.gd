extends Node

@onready var _character_state: CharacterState = Injector.inject(CharacterState, self)
@onready var _biomes_layer_state: BiomesLayerState = Injector.inject(BiomesLayerState, self)
@onready var _world_objects_layer_state: WorldObjectsLayerState = Injector.inject(
	WorldObjectsLayerState, self
)

var _state: CharacterLocationState


func _enter_tree() -> void:
	_state = Injector.provide(CharacterLocationState, CharacterLocationState.new(), self, "closest")


func _ready() -> void:
	_character_state.position_changed.connect(_on_character_position_changed)


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
	if (
		not is_instance_of(_state.current_location, CharacterLocationState.BiomesLocation)
		or _state.current_location.tile_pos != tile_pos
	):
		var biomes = _biomes_layer_state.get_visible_tile_biomes_fast(tile_pos)
		print(biomes)
		_state.current_location = CharacterLocationState.BiomesLocation.new(tile_pos, biomes)
