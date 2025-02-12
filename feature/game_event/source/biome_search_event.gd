class_name EventBiomeSerch
extends EventResource

const _STAGE = {
}


func _get_new_stage_dir() -> Dictionary:
	var dir: Dictionary = STAGE.duplicate() 
	dir.merge(_STAGE.duplicate())
	return dir
