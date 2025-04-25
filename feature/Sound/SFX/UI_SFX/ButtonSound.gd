extends Button
class_name ButtonSound

@export var press_sound_stream:AudioStream = preload("res://assets/sound/click1.ogg")
@export var hover_sound_stream:AudioStream = preload("res://assets/sound/338229__fachii__button-hover.wav")

@onready var sfx_player_state: SfxPlayerState = Locator.get_service(SfxPlayerState)


func _ready():
	connect("pressed", Callable(self, "_on_sound_button_pressed"))
	connect("mouse_entered", Callable(self, "_on_sound_button_entered"))


func _on_sound_button_pressed():
	sfx_player_state.play_sound_from_stream(press_sound_stream)


func _on_sound_button_entered():
	sfx_player_state.play_sound_from_stream(hover_sound_stream)
