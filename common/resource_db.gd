class_name ResourceDb
 

var is_connection_opened: bool:
	get:
		return connection != null
var _path: String = ""
var path: String:
	get:
		return _path

signal connection_changed(connection: Database)	
var connection: Database

func db_connect(connect_path: String):
	if (connection != null):
		connection.close_db()
	
	# FIXME await принемает сигнал для срабатывания
	# ResourceLoader.load_threaded_request возвращает интовую (int) константу ошибки
	await ResourceLoader.load_threaded_request(connect_path)
	connection = ResourceLoader.load_threaded_get(connect_path)
	_path = connect_path
	
	connection_changed.emit(connection)


func db_close():	
	_path = ""
	connection = null
	connection_changed.emit(connection)
