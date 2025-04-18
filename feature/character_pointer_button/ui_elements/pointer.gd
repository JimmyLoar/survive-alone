extends Control

var dir_vector: Vector2 = Vector2.ZERO

var character_state: CharacterState 


func _ready():
	visible = false
	_on_ready_character_state(Locator.get_service(CharacterState, _on_ready_character_state))


func _on_ready_character_state(state: CharacterState):
	if not state:
		return
	
	character_state = state
	state.player_enter_on_screen.connect(enter_screen)
	state.player_exited_from_screen.connect(exit_screen)


func rotate_arrow():
	$"Sprite-0003-export".rotation = (dir_vector).angle() - PI / 2


func _process(delta):
	rotate_arrow()


func enter_screen():
	visible = false
	set_process(false)


func exit_screen():
	visible = true
	set_process(true)


func _on_texture_button_pressed():
	visible = false
	Locator.get_main_camera().mode = MainCameraState.TargetMode.new(character_state._node)
