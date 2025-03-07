extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var delta_label: Label = $DeltaLabel


func set_delta_number(value: int, inverce_colors := false):
	delta_label.text = "%d" % [value]
	delta_label.add_theme_color_override("font_color", get_color(value, inverce_colors))


func set_icon(value: Texture2D):
	icon.texture = value


func get_color(delta: int, inverce_colors: bool) -> Color:
	if inverce_colors: 
		delta *= -1
	match delta:
		var x when x > 0:  return Color(0.3922, 0.8902, 0.2314, 1.0)
		var x when x < 0:  return Color(0.84, 0.1848, 0.2394, 1.0)
	return Color.GHOST_WHITE
