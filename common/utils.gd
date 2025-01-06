class_name  Utils
extends  Object

static func join_to_str(array: Array, separator: String) -> String:
	var result: String = ""
	
	for i in range(array.size()):
		result += str(array[i])
		# Добавляем разделитель только если это не последний элемент
		if i < array.size() - 1:
			result += separator
			
	return result
	
static func find_index(array:Array, callable: Callable) -> int:
	for i in range(0, array.size()):
		if callable.call(array[i]):
			return i

	return -1
