class_name Utils
extends Object

const NUMB_POWERS_2: PackedInt32Array = [ #powers from 0 to 32
	1, 2, 4, 8, 16,
	32, 64, 128, 256, 512,
	1024, 2048, 4096, 8192, 16384,
	32768, 65536, 131072, 262144, 524288,
	1.04858e+06, 2.09715e+06, 4.1943e+06, 8.38861e+06, 1.67772e+07,
	3.35544e+07, 6.71089e+07, 1.34218e+08, 2.68435e+08, 5.36871e+08,
	1.07374e+09, 2.14748e+09, 4.29497e+09,
]

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
