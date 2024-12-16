class_name PropertyGenerater


func _init() -> void:
	push_error("PropertyGenerater is static class!")
	self.free()


static func take_int(_name: String, range_values := [], _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var result = {
		"name": _name,
		"type": TYPE_INT,
		"usage": _usage,
	}
	if not range_values.is_empty():
		result["hint"] = PROPERTY_HINT_RANGE
		result["hint_string"] = "%s,".repeat(range_values.size()) % range_values
	return result 


static func take_float(_name: String, range_values := [], _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var result := take_int(_name, range_values, _usage)
	result.type = TYPE_FLOAT
	return result 


static func take_resource(_name: String, _class_name: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": _name,
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": _class_name,
		"usage": _usage,
	}


static func take_simple_array(_name: String, _subclass_name: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": _name,
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": _subclass_name,
		"usage": _usage,
	}


static func take_string(_name: String, use_multiline := false, read_only := false) -> Dictionary:
	return {
		"name": _name,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_MULTILINE_TEXT if use_multiline else PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_DEFAULT + PROPERTY_USAGE_READ_ONLY if read_only else PROPERTY_USAGE_DEFAULT,
	}


static func take_enum_string(_name: String, enum_string: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var _prop := take_string(_name)
	_prop.merge({
		hint = PROPERTY_HINT_ENUM_SUGGESTION,
		hint_string = enum_string,
		usage = _usage,
	}, true)
	return _prop


static func take_enum_int(_name: String, enum_string: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var _prop = take_int(_name)
	_prop.merge({
		hint = PROPERTY_HINT_ENUM,
		hint_string = enum_string,
		usage = _usage,
	}, true)
	return _prop
