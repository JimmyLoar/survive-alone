extends Button
class_name ButtonSound

@export var press_sound_stream:AudioStream = AudioStreamOggVorbis.load_from_file("res://assets/sound/click1.ogg")

@onready var sfx_player_state: SfxPlayerState = Injector.inject(SfxPlayerState, self)

func _pressed():
	sfx_player_state.play_sound_from_stream(press_sound_stream)
	
