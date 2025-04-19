class_name BiomeEntity
extends Object

var id: int = -1  # uniq
var name: String
var resource: BiomeResource

func _init():
	id = -1
	name = "new biome"
	resource = load("uid://cmt1u58b84x8p")
