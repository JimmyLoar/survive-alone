class_name EventDialoge
extends EventResource

const _STAGE = {
	"who_say": "",
	"what_say": "",
}


func _get_new_stage_dir() -> Dictionary:
	var dir: Dictionary = STAGE.duplicate() 
	dir.merge(_STAGE.duplicate())
	return dir
