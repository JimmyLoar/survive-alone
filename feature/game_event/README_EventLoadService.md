# EventLoadService

Сервис для загрузки EventResource с кэшированием в базе данных.

## Описание

EventLoadService предоставляет методы для загрузки EventResource с автоматическим кэшированием в базе данных. Сервис сначала проверяет наличие ресурса в базе сохранения, и если ресурс найден - возвращает десериализованную версию. Если ресурс не найден в базе, он загружается из файловой системы и автоматически сохраняется в базу для будущего использования.

## Инициализация

Сервис должен быть инициализирован в локаторе DI вместе с EventState:

```gdscript
# В world_screen.gd или другом месте инициализации
Locator.initialize_service(EventRepository, [save_db])
Locator.initialize_service(EventLoadService, [Locator.get_service(EventRepository)])
```

## Методы

### load_event(resource_path: String) -> EventResource

Загружает EventResource по пути. Сначала проверяет наличие в базе сохранения, если есть - возвращает десериализованный ресурс, если нет - загружает из файловой системы и сохраняет в базу.

**Параметры:**
- `resource_path` (String): Путь к ресурсу EventResource

**Возвращает:**
- `EventResource`: Загруженный ресурс или null в случае ошибки

### load_event_instance(resource_path: String) -> EventResource

Загружает EventResource и создает его экземпляр (instance). Работает аналогично `load_event`, но дополнительно вызывает `instantiate()` на загруженном ресурсе.

**Параметры:**
- `resource_path` (String): Путь к ресурсу EventResource

**Возвращает:**
- `EventResource`: Загруженный и инстанцированный ресурс или null в случае ошибки

## Использование

### Базовое использование

```gdscript
var event_load_service = Locator.get_service(EventLoadService)

# Загрузка ресурса
var event = event_load_service.load_event("res://resources/collection/events/prologue/prologue_1.tres")

# Загрузка инстанса
var event_instance = event_load_service.load_event_instance("res://resources/collection/events/prologue/prologue_1.tres")
```

### Интеграция с EventState

EventState теперь использует EventLoadService для десериализации событий:

```gdscript
func deserialize(data: Array) -> void:
	clear()
	var event_load_service = Locator.get_service(EventLoadService)
	for serialized_event in data:
		var event := event_load_service.load_event(serialized_event.path)
		var instance := event.instantiate()
		instance.deserialize(serialized_event.data)
		_events.append(instance)
```

### Интеграция с ActionMethods

Методы для работы с событиями в ActionMethods теперь используют EventLoadService:

```gdscript
func event_start(event_name: String):
	var event_load_service = Locator.get_service(EventLoadService)
	var event_resource = ResourceCollector.find(ResourceCollector.Collection.EVENTS, event_name)
	var event: EventResource = event_load_service.load_event_instance(event_resource.resource_path)
	Locator.get_service(EventState).start_event(event)
```

## Преимущества

1. **Кэширование**: Ресурсы автоматически кэшируются в базе данных
2. **Производительность**: Последующие загрузки того же ресурса происходят быстрее
3. **Централизованное управление**: Все загрузки EventResource проходят через один сервис
4. **Совместимость**: Полностью совместим с существующим кодом
5. **Обработка ошибок**: Корректно обрабатывает случаи с несуществующими файлами

## Зависимости

- `EventRepository`: Для работы с базой данных
- `Utils.path_to_id()`: Для преобразования путей в ID
- `EventResource.serialize()` и `EventResource.deserialize()`: Для сериализации/десериализации

## Тестирование

Для тестирования сервиса можно использовать тестовый скрипт `test_event_load_service.gd`, который проверяет:

1. Загрузку событий из файловой системы
2. Создание инстансов событий
3. Кэширование в базе данных
4. Обработку ошибок с несуществующими файлами 