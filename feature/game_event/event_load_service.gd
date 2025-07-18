class_name EventLoadService

var _event_repository: EventRepository

func _init(event_repository: EventRepository) -> void:
	_event_repository = event_repository

func load_event(resource_path: String) -> EventResource:
	"""
	Загружает EventResource по пути. Сначала проверяет наличие в базе сохранения,
	если есть - возвращает десериализованный ресурс, если нет - загружает из файловой
	системы и сохраняет в базу.
	
	Args:
		resource_path: Путь к ресурсу EventResource
		
	Returns:
		EventResource: Загруженный ресурс
	"""
	var id = Utils.path_to_id(resource_path)
	
	# Пытаемся загрузить из базы сохранения
	var saved_event = _event_repository.get_by_id(id)
	if saved_event != null:
		return saved_event
	
	# Если в базе нет, загружаем из файловой системы
	var event_resource = load(resource_path) as EventResource
	if event_resource == null:
		printerr("EventLoadService: Не удалось загрузить ресурс по пути: %s" % resource_path)
		return null
	
	# Сохраняем в базу для будущего использования
	_event_repository.insert(event_resource)
	
	return event_resource

func load_event_instance(resource_path: String) -> EventResource:
	"""
	Загружает EventResource и создает его экземпляр (instance).
	Сначала проверяет наличие в базе сохранения,
	если есть - возвращает десериализованный ресурс, если нет - загружает из файловой
	системы и сохраняет в базу.
	
	Args:
		resource_path: Путь к ресурсу EventResource
		
	Returns:
		EventResource: Загруженный и инстанцированный ресурс
	"""
	var event_resource = load_event(resource_path)
	if event_resource == null:
		return null
	
	return event_resource.instantiate()
