extends Control

@onready var character_state: CharacterState = Injector.inject(CharacterState, self)
@onready var camera_state: MainCameraState = Injector.inject(MainCameraState, self)

func _ready():
	character_state.player_enter_on_screen.connect(enter_screen)
	character_state.player_exited_from_screen.connect(exit_screen)

func rotate_arrow():
	var g_pos = camera_state.global_position + position + Vector2(0, 32) - (camera_state.viewport_rect.size / (2 / camera_state.zoom.x ))
	$"Sprite-0003-export".rotation = (g_pos - character_state.global_position).angle() + PI/2

func _process(delta):
	rotate_arrow()

func enter_screen():
	visible = false
	set_process(false)

func exit_screen():
	visible = true
	set_process(true)


func _on_texture_button_pressed():
	camera_state.mode = MainCameraState.TargetMode.new(character_state._node)
