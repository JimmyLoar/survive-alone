extends Control
class_name CraftPanelView

var recipe: BasicRecipe
@onready var _state = Injector.inject(CraftState, self)

var names = []


var disabled: bool = true:
	set(value):
		_disable_change(value)

func _ready():
	var recipe_view = load("res://feature/craft/ui/RecipeView.tscn").instantiate()
	recipe_view.setup(recipe)
	%RecipeViewContainer.add_child(recipe_view)
	%Time.text = str(recipe.craft_time)
	
	disabled = recipe not in _state.known_recipes
	
	_state.material_changed.connect(_on_item_add_or_substract)
	_state.recipe_added.connect(_on_recipe_added)
	
	for x in recipe.ingredients:
		names.append(x.item.code_name)
	
	Callable(func():
		upd_button()
	).call_deferred()


func _on_craft_button_pressed():
	_state.craft_from_recipe(recipe)

func _on_recipe_added(new_recipe: BasicRecipe):
	if new_recipe == recipe:
		disabled = false

func _on_item_add_or_substract(item):
	if item in names:
		upd_button()
		
func upd_button():
	if disabled:
		return
	if _state.recipe_can_be_crafted(recipe):
		%Craft_button.disabled = false
	else:
		%Craft_button.disabled = true
		
func _disable_change(new: bool):
	if new:
		$DisabledColor.visible = true
		%Craft_button.disabled = true
	else:
		$DisabledColor.visible = false
		%Craft_button.disabled = false
