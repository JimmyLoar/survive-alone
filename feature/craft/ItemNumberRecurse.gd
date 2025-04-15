extends Resource
class_name ItemNumberTuple

#максимум 999 предмета

@export_range(1, 999) var amount:int = 1
@export var item: ItemResource
