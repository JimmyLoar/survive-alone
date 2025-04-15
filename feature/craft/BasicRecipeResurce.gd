extends Resource
class_name BasicRecipe

enum RECIPE_TYPE{
	ALL,
	MEDICK,
	WEAPON,
}



@export var ingredients: Array[ItemNumberTuple]
@export var results: Array[ItemNumberTuple]
@export var craft_time: int = 10
@export var recipe_type: RECIPE_TYPE = RECIPE_TYPE.ALL
