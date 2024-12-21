class_name RegionMapState
extends Node

# right and bottom edges are not included
var _visible_chunks_rect: Rect2i
signal visible_chunks_rect_changed(value: Rect2i)
var visible_chunks_rect: Rect2i:
	set(value):
		# set and emmit the signal only for realy changed value
		if (_visible_chunks_rect != value):
			_visible_chunks_rect = value
			visible_chunks_rect_changed.emit(value)
	get:
		return _visible_chunks_rect

var _visible_chunks: Array[RegionMapChunkState] # Dictionary<Vector2i, ChunkState>
# emits only when chunk added or removed from _visible_chunks
signal visible_chunks_changed(value: Array[RegionMapChunkState])
