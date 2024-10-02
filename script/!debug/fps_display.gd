extends CanvasLayer

var label := Label.new()
func _ready() -> void:
	layer = 100
	add_child(label)

func _process(delta: float) -> void:
	label.text = "FPS: %s" % Engine.get_frames_per_second()
