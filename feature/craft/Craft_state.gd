extends Injectable
class_name CraftState

var _lambda: Callable
var _inventory_state: InventoryCharacterState
var _time_state: GameTimeState

var known_recipes: Array[BasicRecipe] = [
	load("res://feature/craft/testrec.tres"),
	load("res://feature/craft/ui/Recepies/test2.tres"),
	load("res://feature/craft/ui/Recepies/new_resource.tres"),
	load("res://feature/craft/ui/Recepies/new_resource.tres"),
	load("res://feature/craft/ui/Recepies/new_resource.tres"),
	]

func _init() -> void:
	Callable(func():
		_init_dependencies()
	).call_deferred()


func _init_dependencies():
	_inventory_state = Locator.get_service(InventoryCharacterState)
	_time_state = Locator.get_service(GameTimeState)
	_inventory_state.item_added.connect(_on_inventory_change)
	_inventory_state.item_removed.connect(_on_inventory_change)


func craft_from_recipe(recipe: BasicRecipe):
	if recipe_can_be_crafted(recipe):
		if !_time_state:
			_time_state = Locator.get_service(GameTimeState)
		_lambda = Callable(func(x):  if x == 0: _fulfill(recipe))
		_time_state.finished_skip.connect(_lambda)
		_time_state.timeskip(recipe.craft_time, 3.0, true)


func _fulfill(recipe: BasicRecipe):
	_time_state.finished_skip.disconnect(_lambda)
	for tuple in recipe.ingredients:
		_inventory_state.remove_item(tuple.item.code_name, tuple.amount)
	for tuple in recipe.results:
		_inventory_state.add_item(tuple.item, tuple.amount)
	

func recipe_can_be_crafted(recipe: BasicRecipe) -> bool:
	if not is_recipe_known(recipe):
		return false
	
	for tuple in recipe.ingredients:
		if !_inventory_state.has_item_amount(tuple.item.code_name, tuple.amount):
			return false
	return true


func is_recipe_known(recipe: BasicRecipe) -> bool:
	return recipe in known_recipes
	

func add_recipe(recipe: BasicRecipe):
	if recipe not in known_recipes:
		known_recipes.append(recipe)


signal material_changed(material_name: String)


func _on_inventory_change(item_name):
	material_changed.emit(item_name)
