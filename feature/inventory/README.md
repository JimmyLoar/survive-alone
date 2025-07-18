# Inventory

## Назначение
Система управления инвентарем персонажа и локаций. Обеспечивает хранение, добавление, удаление и отслеживание предметов с автоматическим обновлением UI.

## Ответственность
- **Хранение предметов**: Управление коллекцией предметов с количеством
- **Операции с предметами**: Добавление, удаление, поиск предметов
- **Валидация**: Проверка наличия предметов и их количества
- **Кэширование**: Оптимизация поиска предметов по имени
- **UI синхронизация**: Автоматическое обновление отображения при изменениях
- **Интеграция**: Подключение к системе суммирования инвентарей

## Интерфейсы

### Входящие сигналы
- `ItemEntity.quantity_changed` - изменение количества предмета

### Исходящие сигналы
- `changed_entity(InventoryEntity)` - изменение содержимого инвентаря

### Публичные методы
- `add_item(uid: String, value: Variant)` - добавить предмет
- `remove_item(name: String, amount: int)` - удалить предмет
- `has_data(name: String)` - проверить наличие предмета
- `has_item_amount(name: String, amount: int)` - проверить количество предмета
- `find_and_get_amount(name: String)` - получить количество предмета
- `get_items()` - получить все предметы
- `clear_empty()` - удалить пустые слоты

### Зависимости
- `InventoryRepository` - сохранение данных инвентаря
- `InventoryPageDisplay` - отображение содержимого
- `ItemInformation` - информация о предметах
- `SummedInventory` - система суммирования инвентарей

## Конфигурация
- `inventory_display` - компонент отображения инвентаря
- `item_information` - компонент информации о предметах 