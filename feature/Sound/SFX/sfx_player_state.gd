class_name SfxPlayerState
 

var _node

func _init(node) -> void:
	_node = node


func play_sound_from_file(filepath) -> void:
	if filepath is AudioStream:
		pass
	
	if FileAccess.file_exists(filepath):
		_node.play_sound(load(filepath))
	else:
		print(filepath, 'не найден')
	
func play_sound_from_stream(stream: AudioStream):
	_node.play_sound(stream)
