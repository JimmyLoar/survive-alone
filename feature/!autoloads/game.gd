extends Node

signal player_changed_location


var _last_location: WorldObject = null
var _current_location: WorldObject

func set_player_location(new_data: WorldObject):
	if not new_data:
		_current_location = _last_location
	
	else:
		_last_location = _current_location
		_current_location = new_data
	
	var _name := "null"
	if _current_location:
		_name = _current_location.data.name_key
	GodotLogger.debug("Player changed location on [color=green]%s[/color]" % _name)
	player_changed_location.emit()


func get_player_location():
	return _current_location


func get_world_screen() -> WorldScreen:
	return get_tree().root.get_node("WorldScreen")
