class_name ChunkNode
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var bg: Sprite2D = $BG

@onready var structure_container: Node2D = $StructureContainer


var data: ChunkData: set = set_data

var logger : Log

func _ready() -> void:
	logger = GodotLogger.with("Chunk [color=purple]%s[/color]" % data.position)
	structure_container.logger = logger


func set_data(value: ChunkData):
	data = value
	call_deferred("update")


func update():
	if not bg: bg = $BG
	if not structure_container: structure_container = $StructureContainer
	
	bg.texture = data.structure_image
	structure_container.set_structure_list(data.objects)


func get_chunk_position() -> Vector2i:
	if not data: 
		return Vector2i(-1, -1)
	return data.position
