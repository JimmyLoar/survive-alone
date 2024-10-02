extends Node2D


@onready var chunk_container: Node2D = $ChunkContainer
@onready var character: Character = $Character

func _ready() -> void:
	character.changed_chunk.connect(chunk_container.update_region)
	
	chunk_container.update_region(
		character.get_chunk_position()
		)
	
