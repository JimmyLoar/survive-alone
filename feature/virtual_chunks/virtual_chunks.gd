extends Node

var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16)
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  

var _state: VirtualChunksState

func _enter_tree() -> void:
	_state = Locator.initialize_service(VirtualChunksState)
	Locator.get_service(MainCameraState, _on_ready_main_camera)


func _on_ready_main_camera(camera: MainCameraState):
	camera.viewport_rect_changed.connect(Callable(self, "_on_main_camera_viewport_changed"))


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
