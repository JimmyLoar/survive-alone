extends Control

var dir_vector: Vector2 = Vector2.ZERO

@onready var character_state: CharacterState = Injector.inject(CharacterState, self)
@onready var camera_state: MainCameraState = Injector.inject(MainCameraState, self)


func _ready():
	visible = false
	character_state.player_enter_on_screen.connect(enter_screen)
	character_state.player_exited_from_screen.connect(exit_screen)


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
	camera_state.mode = MainCameraState.TargetMode.new(character_state._node)
