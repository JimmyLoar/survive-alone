extends ContentContainer

var _state: CraftState

@onready var game_time: GameTimeState = Injector.inject(GameTimeState, self)

func _enter_tree() -> void:
	_state = Injector.provide(CraftState, CraftState.new(self, game_time), self, Injector.ContainerType.CLOSEST)

func _ready():
	$_MarginContainer/HBoxContainer/MainContainer/RecipesMenu.update_recipe_list()
