class_name PropertyGenerater


func _init() -> void:
	push_error("PropertyGenerater is static class!")
	self.free()


static func take_int(_name: String, range_values := [], _usage: int = PROPERTY_USAGE_DEFAULT):
	var result = {
		"name": _name,
		"type": TYPE_INT,
		"usage": _usage,
	}
	if not range_values.is_empty():
		result["hint"] = PROPERTY_HINT_RANGE
		result["hint_string"] = "%s,".repeat(range_values.size()) % range_values
	return result 


static func take_custom_resource(_name: String, _class_name: String, _usage: int = PROPERTY_USAGE_DEFAULT):
	return {
		"name": _name,
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": _class_name,
		"usage": _usage,
	}

static func take_simple_array(_name: String, _subclass_name: String, _usage: int = PROPERTY_USAGE_DEFAULT):
	return {
		"name": _name,
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": _subclass_name,
		"usage": _usage,
	}
