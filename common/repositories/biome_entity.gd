class_name BiomeEntity
extends Object

enum BiomeType {
	Forest = 0,
	Grass = 1
}

static var FOREST_TYPE = BiomeType.Forest
static var GRASS_TYPE = BiomeType.Grass
static var ALL_TYPES: Array[BiomeType] = [FOREST_TYPE, GRASS_TYPE]

var id: int = -1 # uniq
var name: String
var type: BiomeType
