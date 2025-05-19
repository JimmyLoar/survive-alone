@tool
extends EditorScript

const DB_PATH = "res://databases/test_editor.db"
const OUTPUT_PATH = "res://databases/db_config.gd"

var _db_instance: SQLite = null

func _run():
	print("Database processor started...")
	
	# Получаем объект базы данных с защитой
	var db = get_db_instance()
	if db == null:
		printerr("Failed to initialize database connection")
		return
	
	if FileAccess.file_exists(DB_PATH) or Engine.is_editor_hint():
		export_database(db)
	else:
		db = import_database()
	
	# Обязательно закрываем соединение
	db.close_db()
	print("Processing completed!")

# Безопасное получение объекта базы данных
func get_db_instance() -> SQLite:
	if _db_instance != null and _db_instance.open_db():
		return _db_instance
	
	_db_instance = SQLite.new()
	if _db_instance == null:
		printerr("Failed to create SQLite instance")
		return null
	
	_db_instance.path = DB_PATH
	_db_instance.verbosity_level = 1  # Увеличиваем уровень логгирования
	
	if not _db_instance.open_db():
		printerr("Failed to open database:", _db_instance.error_message)
		return null
	
	return _db_instance

func export_database(db: SQLite):
	db.read_only = true  # Открываем только для чтения
	
	var db_data = {}
	var tables = get_table_names(db)
	
	if tables.is_empty():
		printerr("No tables found in database")
		return
	
	for table in tables:
		if db.query("SELECT * FROM " + table):
			db_data[table] = db.query_result.duplicate()
		else:
			printerr("Failed to query table:", table, "Error:", db.error_message)
	
	if db_data.is_empty():
		printerr("No data found in database")
		return
	
	save_config_file(db_data)
	print("Config file created:", OUTPUT_PATH)

func get_table_names(db: SQLite) -> Array:
	var tables = []
	if db.query("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"):
		for row in db.query_result:
			tables.append(row["name"])
	else:
		printerr("Failed to get table list:", db.error_message)
	return tables

func import_database():
	if not FileAccess.file_exists(OUTPUT_PATH):
		printerr("Config file not found")
		return
	
	var config = load(OUTPUT_PATH).new()
	if config == null:
		printerr("Failed to load config script")
		return
	
	var db_data = config.get_db_structure()
	if db_data.is_empty():
		printerr("Empty database structure in config")
		return
	
	var db = get_db_instance()
	if db == null:
		return
	
	db.foreign_keys = true  # Включаем поддержку внешних ключей
	
	if restore_database(db, db_data):
		print("Database restored successfully. Last insert rowid:", db.last_insert_rowid)
	else:
		printerr("Failed to restore database:", db.error_message)
	return db

func restore_database(db: SQLite, db_data: Dictionary) -> bool:
	for table in db_data:
		# Безопасное удаление таблицы
		if not db.drop_table(table):
			if not db.query("DROP TABLE IF EXISTS " + table):
				printerr("Failed to drop table:", table, "Error:", db.error_message)
				return false
		
		# Определяем структуру таблицы
		var table_structure = {}
		if db_data[table].size() > 0:
			for column in db_data[table][0].keys():
				table_structure[column] = "TEXT"  # Упрощение - все поля TEXT
		
		# Создаем таблицу с обработкой ошибок
		if not db.create_table(table, table_structure):
			printerr("Failed to create table:", table, "Error:", db.error_message)
			return false
		
		# Вставляем данные с проверкой
		if not db.insert_rows(table, db_data[table]):
			printerr("Failed to insert data into table:", table, "Error:", db.error_message)
			return false
	
	return true

func save_config_file(db_data: Dictionary):
	var output = PackedStringArray()
	
	# Заголовок файла
	output.append('@tool')
	output.append('extends RefCounted')
	output.append('')
	output.append('# SQLite Database Configuration')
	output.append('# Generated: %s' % Time.get_datetime_string_from_system())
	output.append('')
	output.append('func get_db_structure() -> Dictionary:')
	output.append('\treturn {')
	
	# Данные таблиц
	for table in db_data:
		output.append('\t\t"%s": %s,' % [table, JSON.stringify(db_data[table], "\t")])
	
	output.append('\t}')
	output.append('')
	
	# Метод для восстановления
	output.append('static func restore_database() -> bool:')
	output.append('\tvar db = SQLite.new()')
	output.append('\tif db == null:')
	output.append('\t\tprinterr("Failed to create SQLite instance")')
	output.append('\t\treturn false')
	output.append('')
	output.append('\tdb.path = "%s"' % DB_PATH)
	output.append('\tdb.foreign_keys = true')
	output.append('\tif not db.open_db():')
	output.append('\t\tprinterr("Failed to open DB:", db.error_message)')
	output.append('\t\treturn false')
	output.append('')
	output.append('\tvar config = load("%s").new()' % OUTPUT_PATH)
	output.append('\tif config == null:')
	output.append('\t\tdb.close_db()')
	output.append('\t\tprinterr("Failed to load config")')
	output.append('\t\treturn false')
	output.append('')
	output.append('\tvar data = config.get_db_structure()')
	output.append('\tif data.is_empty():')
	output.append('\t\tdb.close_db()')
	output.append('\t\tprinterr("Empty database structure")')
	output.append('\t\treturn false')
	output.append('')
	output.append('\tvar success = true')
	output.append('\tfor table in data:')
	output.append('\t\tif not db.drop_table(table):')
	output.append('\t\t\tif not db.query("DROP TABLE IF EXISTS " + table):')
	output.append('\t\t\t\tprinterr("Failed to drop table:", table, "Error:", db.error_message)')
	output.append('\t\t\t\tsuccess = false')
	output.append('\t\t\t\tcontinue')
	output.append('')
	output.append('\t\tvar structure = {}')
	output.append('\t\tif data[table].size() > 0:')
	output.append('\t\t\tfor col in data[table][0]:')
	output.append('\t\t\t\tstructure[col] = "TEXT"')
	output.append('')
	output.append('\t\tif not db.create_table(table, structure):')
	output.append('\t\t\tprinterr("Failed to create table:", table, "Error:", db.error_message)')
	output.append('\t\t\tsuccess = false')
	output.append('\t\t\tcontinue')
	output.append('')
	output.append('\t\tif not db.insert_rows(table, data[table]):')
	output.append('\t\t\tprinterr("Failed to insert data:", table, "Error:", db.error_message)')
	output.append('\t\t\tsuccess = false')
	output.append('')
	output.append('\tdb.close_db()')
	output.append('\treturn success')
	
	# Сохраняем файл с обработкой ошибок
	var file = FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if file:
		file.store_string('\n'.join(output))
		file.close()
	else:
		printerr("Failed to save config file:", FileAccess.get_open_error())

# Метод для диагностики
func print_db_status(db: SQLite):
	if db == null:
		print("Database: NOT INITIALIZED")
		return
	
	print("Database status:")
	print("- Path:", db.path)
	print("- Read-only:", db.read_only)
	print("- Foreign keys:", db.foreign_keys)
	print("- Last insert rowid:", db.last_insert_rowid)
	print("- Last error:", db.error_message)
	print("- Verbosity level:", db.verbosity_level)
