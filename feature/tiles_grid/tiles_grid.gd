extends Node2D

@onready var _mesh = %SDFShaderSquareGrid
@onready var _camera_state: MainCameraState = Injector.inject(MainCameraState, self)
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  

func _ready() -> void:
	var line_width = 1
	var grid_offset = Vector2(0, 0)
	var map_size_in_chunks = Vector2(136, 72) # Взять из конфига ?
	var grid_size_in_tiles = map_size_in_chunks * chunk_size

	var mesh = _mesh.mesh as QuadMesh
	var material = _mesh.material as ShaderMaterial
	
	mesh.size = grid_size_in_tiles * tile_size + Vector2(line_width, line_width)
	material.set_shader_parameter("grid_offset", grid_offset)
	material.set_shader_parameter("square_size", tile_size)
	material.set_shader_parameter("line_width", line_width)
	material.set_shader_parameter("zoom", _camera_state.zoom.x)

	_mesh.show()
	
	_camera_state.viewport_rect_changed.connect(on_camera_zoom_changed)
	

func on_camera_zoom_changed(__):
	var material = _mesh.material as ShaderMaterial
	material.set_shader_parameter("zoom", _camera_state.zoom.x)
