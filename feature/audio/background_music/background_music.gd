extends Node2D


func _ready():
	if not OS.is_debug_build():
		$AudioStreamPlayer.play()
