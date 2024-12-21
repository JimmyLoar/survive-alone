extends Node2D

@onready var state: RegionMapState = %State
@onready var visible_chunks: Node2D = %VisibleChunks
@onready var chunks_pool: Node2D = %ChunksPool

func _enter_tree() -> void:
	# provide self to root contaner
	Injector.provide(Tokens.RegionMapFeature, self)
	# provide feature state to self container
	Injector.provide(Tokens.FeatureState, state, self)
	
func _ready() -> void:
	state.visible_chunks_rect_changed.connect(Callable(self, "_on_visible_chunks_rect_changed"))
	state.visible_chunks_changed.connect(Callable(self, "_on_visible_chunks_changed"))

func _on_visible_chunks_rect_changed(rect: Rect2i):
	var chunks: Array[RegionMapChunkState] = state._visible_chunks.filter(
		func(chunk: RegionMapChunkState): return rect.has_point(chunk.position)
	)
	
	for x in range(rect.position.x, rect.size.x):
		for y in range(rect.position.y, rect.size.y):
			var position = Vector2i(x, y)
			var has_chunk = chunks.find(
				func(chunk: RegionMapChunkState): return chunk.position == position
			) >= 0
			
			if not has_chunk:
				

func _on_visible_chunks_changed(chunks: Array[RegionMapChunkState]):
	pass
