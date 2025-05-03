class_name CraftState

var _lambda: Callable
var _inventory_state: InventoryCharacterState
var _time_state: GameTimeState


var known_recipes: Array[BasicRecipe] = [
	load("res://resources/collection/recipes/tools/tool_homemade_axe.tres"),
	]

var recipes: Array[BasicRecipe] = [
	load("res://resources/collection/recipes/new_resource.tres"),
	load("res://resources/collection/recipes/test2.tres"),
	load("res://resources/collection/recipes/tools/tool_homemade_axe.tres"),
	load("res://resources/collection/recipes/testrec.tres"),
	]


func _init() -> void:
	_init_dependencies.call_deferred()
	add_recipe(load("res://resources/collection/recipes/testrec.tres"))


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


signal recipe_added(recipe: BasicRecipe)


func add_recipe(recipe: BasicRecipe):
	if recipe not in known_recipes:
		known_recipes.append(recipe)
		recipes.sort_custom(func(x, y): y in known_recipes or x in known_recipes)
		recipe_added.emit(recipe)


signal material_changed(material_name: String)


func _on_inventory_change(item_name):
	material_changed.emit(item_name)
