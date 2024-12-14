extends CanvasLayer

@export var character: Character

@onready var quick_bar: PanelContainer = %QuickBar
@onready var tab_container: TabContainer = %TabContainer

enum CMKeys{INVENTORY, LOCATION}

@onready var _content_menus := {
	CMKeys.INVENTORY: $"VBoxContainer/HBoxContainer/TabContainer/CM Inventory",
	CMKeys.LOCATION: $"VBoxContainer/HBoxContainer/TabContainer/CM Loacation",
}

func _ready() -> void:
	var database: Database = load(ProjectSettings.get_setting("resource_databases/main_base_path", "res://database.gddb"))
	var _inventory_controller = Game.get_world_screen().get_inventories_controller()
	var local_inv := _inventory_controller.get_inventory("player")
	local_inv.add_item(database.fetch_data_string("items/primus"), 1)
	local_inv.add_item(database.fetch_data_string("items/water_clear"), 10)
	local_inv.add_item(database.fetch_data_string("items/fresh_meat"), 15)
	
	quick_bar.button_pressed.connect(tab_container.set_current_tab)
	quick_bar.button_pressed.connect(character.controller._stop)
	tab_container.set_current_tab(-1)
	

func get_content_menu(key: CMKeys):
	return _content_menus


func set_time_counter(_counter: GameTimeCounter):
	$VBoxContainer/StatusPanel/MarginContainer/HBoxContainer/Label.game_time = _counter
	
