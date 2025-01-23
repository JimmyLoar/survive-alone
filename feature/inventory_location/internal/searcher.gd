class_name Searcher

var rng := RandomNumberGenerator.new()


func _init(seed := -1) -> void:
	if seed == -1:
		rng.randomize()
	else:
		rng.seed = seed


func search(drop: SearchDropResource) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for i in drop.items_count:
		result.append(_count_item(i, drop))
	rng.randomize()
	return result


func _count_item(index: int, drop: SearchDropResource) -> Dictionary:
	var _item = {
		"data": drop.get_value(index, drop.Value.DATA),
		"amount": 0.0,
		"loops": 0,
	}

	var attempt_value = rng.randf()
	var currect_chance = _count_chance(
		drop.get_value(index, drop.Value.CHANCE),
		drop.get_value(index, drop.Value.REDUCTION),
		_item.loops
	)
	while attempt_value <= currect_chance:
		_item.loops += 1
		_item.amount += drop.get_value(index, drop.Value.REWARD)
		currect_chance = _count_chance(
			drop.get_value(index, drop.Value.CHANCE),
			drop.get_value(index, drop.Value.REDUCTION),
			_item.loops
		)
		attempt_value = rng.randf()

	_item["chance"] = attempt_value
	return _item


func _count_chance(base_chance: float, reduction: float, loop: int) -> float:
	return min(1.0, base_chance / pow(reduction, loop))
