class_name FpsDisplay
extends CanvasLayer

var label := Label.new()
func _ready() -> void:
	name = "FpsDisplay"
	label.position.x = 20
	layer = 100
	add_child(label)


func _process(delta: float) -> void:
	label.text = "FPS: %s" % Engine.get_frames_per_second()
