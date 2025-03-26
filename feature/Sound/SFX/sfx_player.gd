extends Node2D

const  MAX_STREAMS = 8

var _state
var streams: Array[AudioStreamPlayer] = []
func _enter_tree() -> void:
	_state = Injector.provide(SfxPlayerState, SfxPlayerState.new(self), self, Injector.ContainerType.CLOSEST)

func _ready():
	for i in range(MAX_STREAMS):
		var new_stream = AudioStreamPlayer.new()
		new_stream.bus = "SFX"
		streams.append(new_stream)
		add_child(new_stream)
		
		
func play_sound(sound: AudioStream):
	for stream in streams:
		if not stream.playing:
			stream.stream = sound
			stream.play()
