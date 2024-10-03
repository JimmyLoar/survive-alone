class_name VersionDisplay
extends Label

var label := Label.new()


func _init() -> void:
	set("theme_override_constants/outline_size", 4)
	set("theme_override_colors/font_outline_color", Color("2c1700c8"))
	set("theme_override_colors/font_color", Color("e88d00"))
	set("theme_override_font_sizes/font_size", 16)


func _ready() -> void:
	var version_text: String = "v%d.%d.%d %s" %\
		[
			ProjectSettings.get_setting("application/game/version/major", 0),
			ProjectSettings.get_setting("application/game/version/minor", 0),
			ProjectSettings.get_setting("application/game/version/patch", 0),
			ProjectSettings.get_setting("application/game/version/string", ""),
		]
	
	text = version_text
