extends HBoxContainer
class_name CraftPanelView

var recipe: BasicRecipe
@onready var _state = Injector.inject(CraftState, self)

var names = []

func _ready():
	var recipe_view = load("res://feature/craft/ui/RecipeView.tscn").instantiate()
	recipe_view.setup(recipe)
	$HBoxContainer/PanelContainer/VBoxContainer/MarginContainer.add_child(recipe_view)
	%Time.text = str(recipe.craft_time)
	_state.material_changed.connect(_on_item_add_or_substract)
	for x in recipe.ingredients:
		names.append(x.item.code_name)
	
	Callable(func():
		upd_button()
	).call_deferred()


func _on_craft_button_pressed():
	_state.craft_from_recipe(recipe)


func _on_item_add_or_substract(item):
	if item in names:
		upd_button()
		
func upd_button():
	if _state.recipe_can_be_crafted(recipe):
		%Craft_button.disabled = false
	else:
		%Craft_button.disabled = true
