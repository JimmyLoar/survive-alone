class_name FpsDisplay
extends CanvasLayer

var label := Label.new()
func _ready() -> void:
	name = "FpsDisplay"
	label.position.x = ProjectSettings.get_setting("display/window/size/viewport_width", 1280) - 80 
	label.position.y = 6 + 40
	label.set("theme_override_colors/font_color", Color.CORAL)
	label.set("theme_override_colors/font_shadow_color", Color.BLACK)
	layer = 100
	add_child(label)
	

func _process(delta: float) -> void:
	label.text = "FPS: %s" % Engine.get_frames_per_second()
