@tool
class_name BiomeResource
extends NamedResource

enum BiomeViewType {
	Forest,
	Grass,
	Water,
	Ground
}

@export var view_type = BiomeViewType.Grass
@export var search_drop: SearchDropResource = SearchDropResource.get_none()

func _init() -> void:
	super("Biome")
