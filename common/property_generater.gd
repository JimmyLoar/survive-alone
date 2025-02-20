class_name PropertyGenerater


func _init() -> void:
	push_error("PropertyGenerater is static class!")
	self.free()


static func take_int(property_name: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var result = {
		"name": property_name,
		"type": TYPE_INT,
		"usage": _usage,
	}
	return result 


static func take_float(property_name: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var result := take_int(property_name, _usage)
	result.type = TYPE_FLOAT
	return result 


static func take_bool(property_name: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_BOOL,
		"usage": _usage,
	}


static func take_range_int(property_name: String, min_value: int, max_value: int, step: int = 1, overside: String = '', _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	var dict := take_int(property_name, _usage)
	dict.merge({
		"hint" = PROPERTY_HINT_RANGE,
		"hint_string" = "%d,%d,%d,%s" % [min_value, max_value, step, overside]
	})
	return dict


static func take_string(property_name: String, use_multiline := false, read_only := false) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_MULTILINE_TEXT if use_multiline else PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_DEFAULT + PROPERTY_USAGE_READ_ONLY if read_only else PROPERTY_USAGE_DEFAULT,
	}


static func take_simple_array(property_name: String, elem_type: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": elem_type,
		"usage": _usage,
	}


static func take_array(property_name: String, elem_type: int, elem_hint: int, elem_hint_string: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": "%d/%d:%s" % [elem_type, elem_hint, elem_hint_string],
		"usage": _usage,
	}


static func take_two_dimensional_array(property_name: String, elem_type: int = TYPE_INT, elem_hint: int = PROPERTY_HINT_NONE, elem_hint_string: String = '', _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": "%d:%d/%d:%s" % [TYPE_ARRAY, elem_type, elem_hint, elem_hint_string],
		"usage": _usage,
	}


static func take_free_dimensional_array(property_name: String, elem_type: int = TYPE_INT, elem_hint: int = PROPERTY_HINT_NONE, elem_hint_string: String = '', _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": "%d:%d:%d/%d:%s" % [TYPE_ARRAY, TYPE_ARRAY, elem_type, elem_hint, elem_hint_string],
		"usage": _usage,
	}


static func take_resource(property_name: String, _class_name: String, _usage: int = PROPERTY_USAGE_DEFAULT) -> Dictionary:
	return {
		"name": property_name,
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": _class_name,
		"usage": _usage,
	}


static func take_dictionary(property_name: String, _usage: int = PROPERTY_USAGE_DEFAULT):
	return {
		"name": property_name,
		"type": TYPE_DICTIONARY,
		"usage": _usage,
	}


static func take_flags(property_name: String, flags: PackedStringArray = ["None:0"], _usage: int = PROPERTY_USAGE_DEFAULT):
	return {
		"name": property_name,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": ", ".join(flags).capitalize(),
		"usage": _usage,
	}


static func convent_to_range(property_dict: Dictionary, min_value: float, max_value: float, step: float = 1.0, overside: String = '') -> Dictionary:
	property_dict.merge({
		"hint" = PROPERTY_HINT_RANGE,
		"hint_string" = "%s,%s,%s,%s" % [min_value, max_value, step, overside]
	}, true)
	return property_dict


static func convert_to_enum(property: Dictionary, enum_string: String, is_int_value := true) -> Dictionary:
	property.merge({
		hint = PROPERTY_HINT_ENUM if is_int_value else PROPERTY_HINT_ENUM_SUGGESTION,
		hint_string = enum_string,
	}, true)
	return property
