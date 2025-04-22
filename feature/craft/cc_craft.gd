extends ContentContainer

var _state: CraftState
@onready var game_time: GameTimeState = Locator.get_service(GameTimeState)


func _enter_tree() -> void:
	_state = Locator.initialize_service(CraftState)


func _ready():
	$_MarginContainer/HBoxContainer/MainContainer/RecipesMenu.update_recipe_list()
