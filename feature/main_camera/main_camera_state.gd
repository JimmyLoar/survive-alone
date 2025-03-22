class_name MainCameraState
extends Injectable

var _node: Camera2D
func _init(node: Camera2D) -> void:
	_node = node

var global_position: Vector2:
	get:
		return _node.global_position

var _viewport_rect: Rect2:
	set(value):
		if value != _viewport_rect:
			_viewport_rect = value
			viewport_rect_changed.emit(value)

signal viewport_rect_changed(value: Rect2)
var viewport_rect: Rect2:
	get: return _viewport_rect

var zoom: Vector2:
	get: return _node.zoom


#
# Mode
#

class FreeMode:
	var initial_pos: Vector2


class TargetMode:
	var target: Node2D
	func _init(new_target: Node2D):
		target = new_target

var _mode: Variant = FreeMode.new() # FreeMode | TargetMode
signal mode_changed(mode: Variant)
var mode: Variant:
	get: return _mode
	set(value):
		_mode = value
		mode_changed.emit(value)
