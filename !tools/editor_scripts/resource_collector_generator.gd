@tool
extends EditorScript

const RESOURCES_PATH = "res://resources/collection"
const OUTPUT_PATH = "res://databases/resources_collector.gd"


func _run():
	print("Начинаем генерацию ResourceCollector...")
	generate_resource_collector()
	print("Генерация завершена! Файл сохранен в ", OUTPUT_PATH)


func generate_resource_collector():
	var collections := scan_resources_directory()
	var output := generate_output_file_content(collections)
	
	var file = FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if file:
		file.store_string(output)
	else:
		printerr("Ошибка: Не удалось открыть файл для записи: ", OUTPUT_PATH)


func scan_resources_directory() -> Dictionary:
	var collections := {}
	var dir = DirAccess.open(RESOURCES_PATH)
	
	if not dir:
		return {}
	
	print("	Сканирование %s..." % RESOURCES_PATH)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = RESOURCES_PATH.path_join(file_name)
		if dir.current_is_dir():
			process_subdirectory(full_path, collections)
		file_name = dir.get_next()
	
	return collections


func process_subdirectory(dir_path: String, collections: Dictionary):
	var dir = DirAccess.open(dir_path)
	if not dir:
		printerr("Ошибка: %s" % [error_string(dir.get_open_error())])
		return
	 
	var collection_name = dir_path.get_file()
	collections[collection_name] = {}
	
	print("	Сканирование %s..." % dir_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var uid = get_uid_from_file(dir_path.path_join(file_name))
			if not uid.is_empty():
				var item_name = file_name.get_basename()
				collections[collection_name][item_name] = uid
		file_name = dir.get_next()


func get_uid_from_file(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return ""
	
	var content = file.get_as_text()
	var uid_pos = content.find("uid=")
	if uid_pos == -1:
		return ""
	
	var uid_end = content.find("]", uid_pos)
	return content.substr(uid_pos + 4, uid_end - (uid_pos + 4)).strip_edges()



func generate_output_file_content(collections: Dictionary) -> String:
	var output := PackedStringArray()
	
	# Заголовок файла
	output.append("class_name ResourceCollector")
	output.append("")
	
	# Методы
	output.append_array(generate_warning_block("МЕТОДЫ ДЛЯ РАБОТЫ С РЕСУРСАМИ"))
	output.append("")
	output.append_array(generate_uid_method(collections))
	output.append("")
	output.append_array(generate_find_method())
	output.append("")
	output.append_array(generate_find_multiple_method())
	output.append("")
	output.append_array(generate_find_all_method())
	output.append("")
	output.append_array(generate_keys_method(collections))
	
	# Enum коллекций
	output.append_array(generate_warning_block("НАЗВАНИЯ КОЛЛЕКЦИЙ"))
	output.append("")
	output.append("enum Collection {")
	for collection_name in collections:
		output.append("    %s," % collection_name.to_upper())
	output.append("}")
	output.append("")
	
	# Коллекции ресурсов
	output.append_array(generate_warning_block("КОЛЛЕКЦИИ РЕСУРСОВ"))
	output.append("")
	for collection_name in collections:
		output.append("const %s = {" % collection_name)
		for item_name in collections[collection_name]:
			output.append('    "%s": %s,' % [item_name, collections[collection_name][item_name]])
		output.append("}")
		output.append("")
	
	output.append("")
	output.append_array(generate_warning_block("КОНЕЦ ФАЙЛА"))
	
	return "\n".join(output)


func generate_warning_block(title := "АВТОМАТИЧЕСКИ СГЕНЕРИРОВАННЫЙ ФАЙЛ") -> PackedStringArray:
	var warning := PackedStringArray()
	var pad = (66 - title.length()) / 2
	warning.append("#######################################################################")
	warning.append("#%s %s %s#" % [" ".rpad(pad), title, " ".lpad(pad)])
	warning.append("# WARNING: НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                 #")
	warning.append("# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #")
	warning.append("#######################################################################")
	warning.append("")
	return warning


func generate_uid_method(collections: Dictionary) -> PackedStringArray:
	var method := PackedStringArray()
	method.append("static func uid(collection: Collection, key: String) -> String:")
	method.append('    """Возвращает UID ресурса или пустую строку если не найден"""')
	method.append("    match collection:")
	for collection_name in collections:
		method.append("        Collection.%s:" % collection_name.to_upper())
		method.append("            return %s.get(key, \"\")" % collection_name)
	method.append("        _: return \"\"")
	return method


func generate_find_method() -> PackedStringArray:
	var method := PackedStringArray()
	method.append("static func find(collection: Collection, key: String) -> Resource:")
	method.append('    """Загружает и возвращает один ресурс"""')
	method.append("    var resource_uid := uid(collection, key)")
	method.append("    return ResourceLoader.load(resource_uid) if resource_uid else null")
	return method


func generate_find_multiple_method() -> PackedStringArray:
	var method := PackedStringArray()
	method.append("static func find_multiple(collection: Collection, keys: Array[String]) -> Array[Resource]:")
	method.append('    """Загружает и возвращает массив ресурсов по массиву ключей"""')
	method.append("    var result: Array[Resource] = []")
	method.append("    for key in keys:")
	method.append("        var res := find(collection, key)")
	method.append("        if res:")
	method.append("            result.append(res)")
	method.append("    return result")
	return method


func generate_find_all_method() -> PackedStringArray:
	var method := PackedStringArray()
	method.append("static func find_all(collection: Collection) -> Array[Resource]:")
	method.append('    """Возвращает все ресурсы указанной коллекции"""')
	method.append("    var result: Array[Resource] = []")
	method.append("    for key in keys(collection):")
	method.append("        var res := find(collection, key)")
	method.append("        if res:")
	method.append("            result.append(res)")
	method.append("    return result")
	return method


func generate_keys_method(collections: Dictionary) -> PackedStringArray:
	var method := PackedStringArray()
	method.append("static func keys(collection: Collection) -> Array[String]:")
	method.append('    """Возвращает все ключи указанной коллекции"""')
	method.append("    match collection:")
	for collection_name in collections:
		method.append("        Collection.%s:" % collection_name.to_upper())
		method.append("            return %s.keys()" % collection_name)
	method.append("        _: return []")
	return method
