class_name CharacterPropertyMath

const _template = {
	"exhaustion": 0.0,
	"fatigue": 0.0,
	"hunger": 0.0,
	"psych": 0.0,
	"radiation": 0.0,
	"thirst": 0.0,
}

static var _properties_resources: Array = []


static func count_change_from_delta_time(delta_time: int, _repositiory: CharacterPropertyRepository) -> Dictionary:
	var result = _template.duplicate()
	delta_time = abs(delta_time)
	if delta_time == 0:
		return result
	
	if _properties_resources.is_empty():
		_properties_resources = ResourceCollector.find_all(ResourceCollector.CharacterProperty)
	
	result.exhaustion = count_exhaustion(delta_time, _repositiory)
	#result.fatigue = count_fatigue(delta_time)
	#result.hunger = count_hunger(delta_time)
	#result.psych = count_psych(delta_time)
	#result.radiation = count_radiation(delta_time)
	#result.thirst = count_thirst(delta_time)
	
	return result


static func count_hunger(delta_time: int) -> float:
	const name = "hunger"
	#var entity = _properties_repository.get_by_name(name)
	var value: int = _count_base_delta(name, delta_time)
	#return min(value, entity.get_min_value() - entity.value)
	return 0


static func count_thirst(delta_time: int) -> float:
	const name = "thirst"
	#var entity = _properties_repository.get_by_name(name)
	var value: int = _count_base_delta(name, delta_time)
	return value


static func count_fatigue(delta_time: int) -> float:
	const name = "fatigue"
	#var entity = _properties_repository.get_by_name(name)
	var value: int = _count_base_delta(name, delta_time)
	return value


static func count_exhaustion(delta_time: int, _properties_repository: CharacterPropertyRepository) -> float:
	var name = "exhaustion"
	var entity = _properties_repository.get_by_name(name)
	var value: int = _count_base_delta(name, delta_time)
	return value


static func count_radiation(delta_time: int) -> float:
	const name = "radiation"
	#var entity = _properties_repository.get_by_name(name)
	var value: int = _count_base_delta(name, delta_time)
	return value


static func count_psych(delta_time: int) -> float:
	const name = "psych"
	#var entity = _properties_repository.get_by_name(name)
	var value: int = _count_base_delta(name, delta_time)
	return value


static func _count_base_delta(_res_name: String, delta_time: int) -> float:
	var property :=  _properties_resources[_properties_resources.find_custom(
		func(elm: CharacterPropertyResource): return elm.code_name == _res_name)
	] as CharacterPropertyResource
	return property.default_delta_value * delta_time
