tags:: system, survive_alone

- ## 1. Основа
- ### 1.1. Концепт
- Боевая система — это проверка уровня подготовки игрока (*прокачка*) и способ получения ресурсов (*награды*).
- Бой происходит на отдельном экране, где игрок управляет **персонажем**, а система — **врагом**.
- ### 1.2. Ключевые сущности
- | Термин | Описание |
  | ---- | ---- | ---- |
  | **Персонаж** | Управляемая игроком сущность с набором *скилов* и *эффектов*. |
  | **Враг** | Управляемая ИИ сущность с уникальными паттернами атак. |
  | **Ход** | Промежуток, когда одна сторона совершает действия (1+ *скил*). |
  | **Раунд** | ход игрока + ход противника. |
- ---
- ## 2. Механики боя
- ### 2.1. Базовые элементы
- **Скил (навык)**
	- Способность, требующая времени (*таймер*) и/или ресурсов (например, энергии).
	- Примеры: атака, защита, использование предмета.
- **Эффекты**
	- Пассивные модификаторы (например, *горение*, *ускорение*).
	- Активируются в **начале хода** и исчезают после окончания.
- **Таймер хода**
	- Время до хода противника. Сокращается при использовании *скилов*.
	- Если время < стоимости самого быстрого навыка — ход переходит врагу.
	- Модификатор: **ловкость** (увеличивает таймер).
- **Энергия**
	- Лимит раундов до штрафов (например, *усталость: -40% к таймеру*).
	- Зависит от **бодрости** перед боем.
- ---
- ## **3. Процесс боя**
- ### **3.1. Фазы**
- **Предбоевая подготовка**
	- Игрок выбирает до **3 предметов**, которые становятся доступными как *скилы*.
	- Если предмет имеет несколько применений — откроется подменю с вариантами.
- **Загрузка экрана**
	- Отображение противника, окружения, интерфейса (HP, энергия, таймер).
- **Раунды**
	- Игрок и враг поочередно совершают ходы.
	- Критерий победы: снижение HP врага до 0.
- ---
- ## **4. Внешние механики**
- ### **4.1. Связь с другими системами**
- **Прокачка**
	- Характеристики (ловкость, бодрость) влияют на бой.
	- *Дерево навыков* может давать дополнительные способности.
- **Инвентарь**
	- Предметы из мира можно использовать в бою.
- **Ресурсы**
	- Победа дает материалы для крафта/улучшений.
- **Тренировочный режим**
	- Возможность тестировать скилы без риска.
- ### **4.2. Баланс**
- Сложность врагов растет пропорционально *уровню ухудшения мира*.
- Энергия ограничивает "затяжные" бои, поощряя стратегическое планирование.
- ---
- ## **5. Интерфейс (UI/UX)**
- **Экран боя**:
	- Спрайт персонажа слева, а противника справа.
- **Скилы**:
	- Панель
- **Предметы в бою**:
	- Отдельная панель под кнопками **скилов**.
- ---
- ## **6. Технические требования**
- **Анимации**: Для скилов и эффектов.
- **Система сохранения**: Фиксация результатов боя (награды, потраченные предметы).