extends Node

var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16)
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  

var _state: VirtualChunksState
@onready var _main_camera_state: MainCameraState = Injector.inject(MainCameraState, self)

func _enter_tree() -> void:
	_state = Injector.provide(VirtualChunksState, VirtualChunksState.new(), self, Injector.ContainerType.CLOSEST)

func _ready() -> void:
	_main_camera_state.viewport_rect_changed.connect(Callable(self, "_on_main_camera_viewport_changed"))
	
func _on_main_camera_viewport_changed(viewport: Rect2):
	var chunk_size_in_pixels = chunk_size * tile_size
	var position = Vector2i(
		floor(viewport.position.x / chunk_size_in_pixels) - 1,
		floor(viewport.position.y / chunk_size_in_pixels) - 1
	)

	var size = Vector2i(
		ceil(viewport.end.x / chunk_size_in_pixels) + 1 - position.x,
		ceil(viewport.end.y / chunk_size_in_pixels) + 1 - position.y
	)
	
	_state._visible_chunks_rect = Rect2i(position, size)
