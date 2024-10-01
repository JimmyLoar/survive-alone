class_name WorldObject
extends Area2D

func _ready() -> void:
	name = "WorldObjec %s" % get_index()


func _char_entered(_char: Character):
	print("player entered in '%s' in '%s'" % [self.name, get_parent().name])


func _char_exited(_char: Character):
	print("player exited in '%s' in '%s'" % [self.name, get_parent().name])
