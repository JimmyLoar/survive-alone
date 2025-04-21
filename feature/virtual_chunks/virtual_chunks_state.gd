# Not visible chunks. Just chunk rects to render
# used to render objects only in viewport and closest
class_name VirtualChunksState
 

var _visible_chunks_rect: Rect2i:
	set(value):
		if value != _visible_chunks_rect:
			#print("visible_chunks_rect", value)
			_visible_chunks_rect = value
			visible_chunks_rect_changed.emit(value)
signal visible_chunks_rect_changed(value: Rect2i)
var visible_chunks_rect: Rect2i:
	get: 
		return _visible_chunks_rect
