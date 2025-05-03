extends MarginContainer

var rect: Rect2
var center: Vector2
@onready var camera_state: MainCameraState = Locator.get_service(MainCameraState)
@onready var character_state: CharacterState = Locator.get_service(CharacterState)


func _ready():
	calculate_rect_params.call_deferred()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	calculate_local_vector_to_player()


func calculate_rect_params():
	rect = $ReferenceRect.get_rect()
	center = rect.get_center()


func calculate_local_vector_to_player():
	if not camera_state:
		return
	
	var g_center_pos = camera_state.viewport_rect.position + center / camera_state.zoom.x
	var vector_to_player = (character_state.global_position - g_center_pos) * camera_state.zoom.x
	var half_size = rect.size * 0.5
	if not (abs(vector_to_player.x) <= half_size.x and abs(vector_to_player.y) <= half_size.y):
		var scale_x = half_size.x / abs(vector_to_player.x) if vector_to_player.x != 0 else INF
		var scale_y = half_size.y / abs(vector_to_player.y) if vector_to_player.y != 0 else INF
		var _scale = min(scale_x, scale_y)  # Берём минимальный масштаб, чтобы не выйти за границы
		vector_to_player *= _scale

	$Pointer.position = vector_to_player + center
	$Pointer.dir_vector = vector_to_player
