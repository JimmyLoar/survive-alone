# Features

## Обзор архитектуры

Папка `feature` содержит модульные системы игры, каждая из которых отвечает за определенную функциональность. Все фичи используют паттерн State для управления состоянием и систему Locator для зависимостей.

## Основные фичи

### Игровые системы
- **[Character](character/README.md)** - основной игровой персонаж
- **[Game Time](game_time/README.md)** - управление игровым временем
- **[Actions](actions/README.md)** - система действий и условий
- **[Game Event](game_event/README.md)** - игровые события и диалоги

### Инвентарь и предметы
- **[Inventory](inventory/README.md)** - базовая система инвентаря
- **[Inventory Character](inventory_character/README.md)** - инвентарь персонажа
- **[Inventory Location](inventory_location/README.md)** - инвентарь локаций
- **[Items](items/README.md)** - система предметов
- **[Items Grid](items_grid/README.md)** - отображение предметов в сетке
- **[Item Action](item_action/README.md)** - действия с предметами

### Мир и визуализация
- **[Biomes Layer](biomes_layer/README.md)** - отображение биомов
- **[World Objects Layer](world_objects_layer/README.md)** - мировые объекты
- **[Virtual Chunks](virtual_chunks/README.md)** - оптимизация рендеринга
- **[Virtual Chunks Grid](virtual_chunks_grid/README.md)** - отображение чанков
- **[Tiles Grid](tiles_grid/README.md)** - отображение тайлов
- **[Main Camera](main_camera/README.md)** - основная камера

### Игровые механики
- **[Craft](craft/README.md)** - система крафтинга
- **[Rest](rest/README.md)** - система отдыха
- **[Quest Viewer](quest_viewer/README.md)** - просмотр квестов

### UI и взаимодействие
- **[Character Properties Bar](character_properties_bar/README.md)** - панель характеристик
- **[Character Pointer Button](character_pointer_button/README.md)** - указатель на персонажа
- **[Character Location](character_location/README.md)** - локация персонажа
- **[Quantity Selector](quantity_selector/README.md)** - выбор количества
- **[UI Content Menu](ui_content_menu/README.md)** - контекстные меню
- **[Screen Mouse Events](screen_mouse_events/README.md)** - события мыши

### Утилиты
- **[FPS Display](fps_display/README.md)** - отображение FPS
- **[Sound](Sound/README.md)** - управление звуком
- **[Execute Keeper](execute_keeper/README.md)** - управление операциями

## Принципы архитектуры

### State Pattern
Каждая фича имеет соответствующий State класс для управления состоянием:
- `CharacterState` для Character
- `GameTimeState` для Game Time
- `InventoryState` для Inventory
- и т.д.

### Dependency Injection через Locator
Все зависимости получаются через систему Locator:
```gdscript
@onready var _character_state: CharacterState = Locator.get_service(CharacterState)
```

### Сигналы для коммуникации
Фичи взаимодействуют через сигналы:
- `position_changed` - изменение позиции
- `property_changed` - изменение характеристики
- `inventory_changed` - изменение инвентаря

### Модульность
Каждая фича самодостаточна и может работать независимо, взаимодействуя с другими через четко определенные интерфейсы.

## Добавление новой фичи

1. Создать папку с именем фичи
2. Создать основной класс фичи (например, `my_feature.gd`)
3. Создать State класс (`my_feature_state.gd`)
4. Создать README.md с описанием назначения, ответственности и интерфейсов
5. Зарегистрировать State в Locator при необходимости 