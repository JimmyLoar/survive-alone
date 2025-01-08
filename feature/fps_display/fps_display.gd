class_name FpsDisplay
extends Label

func _ready() -> void:
	set("theme_override_colors/font_color", Color.CORAL)
	set("theme_override_colors/font_shadow_color", Color.BLACK)
	

func _process(delta: float) -> void:
	text = "FPS: %s" % Engine.get_frames_per_second()
