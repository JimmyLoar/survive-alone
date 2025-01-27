extends Label


@export var zero_color:Color = Color(0.4102, 0.4102, 0.4102, 1)
@export var positive_color:Color = Color(0.3907, 0.8906, 0.2309, 1)
@export var negative_color:Color = Color(0.6875, 0.1901, 0.2368, 1)

func set_delta_number(delta: float):
	text = str(delta)
	if delta == 0:
		add_theme_color_override("font_color",	zero_color)
	if delta > 0:
		add_theme_color_override("font_color", positive_color)
		text = '+' + text
	if delta < 0:
		add_theme_color_override("font_color", negative_color)
	pass
