class_name Utils
extends Object


static func join_to_str(array: Array, separator: String) -> String:
	var result: String = ""

	for i in range(array.size()):
		result += str(array[i])
		# Добавляем разделитель только если это не последний элемент
		if i < array.size() - 1:
			result += separator

	return result


static func find_index(array: Array, callable: Callable) -> int:
	for i in range(0, array.size()):
		if callable.call(array[i]):
			return i

	return -1


static func find_first(array: Array, callable: Callable) -> Variant:
	for i in range(0, array.size()):
		if callable.call(array[i]):
			return array[i]

	return null


static func create_dictionary_with_keys(keys_array: Array, filling_value: Variant = null) -> Dictionary:
	var dict := {}
	for key in keys_array:
		dict[key] = filling_value
	return dict


static func dictionary_erase_keys_without_list(dict: Dictionary, keys_list: Array) -> Dictionary:
	var new_dict := {}
	for key in dict:
		if keys_list.has(key): 
			new_dict[key] = dict[key]
	#print_debug("old dict: %s\n keylist: %s\nnew dict: %s" % [dict, keys_list, new_dict])
	return new_dict 
