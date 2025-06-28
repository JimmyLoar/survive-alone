extends MarginContainer

signal finished

@onready var grid_container: GridContainer = $GridContainer
@onready var _inventory_location: InventoryLocation = Locator.get_service(InventoryLocation)
@onready var _inventory_repository: InventoryRepository = Locator.get_service(InventoryRepository)


func update(drop: SearchDropResource):
	if not drop: 
		hide()
		return
	
	var items := drop.get_items()
	items.resize(grid_container.get_child_count())
	for i in grid_container.get_child_count():
		var data: String = ""
		if items[i].size() > 0:
			data = items[i][0]
		grid_container.get_child(i).update(ResourceCollector.find(ResourceCollector.Items, data))
	show()


func start_search(drop: Array[Dictionary]):
	for i in grid_container.get_child_count():
		var child: Control = grid_container.get_child(i)
		if not child.visible: continue
		_finished_amount += 1
		child.show_progress(drop[i].loops, drop[i].chance, drop[i].amount)
		child.finished.connect(_on_finished_search.bind(drop), CONNECT_ONE_SHOT)


var _finished_amount := 0
func _on_finished_search(_child_index: int, drop: Array[Dictionary]):
	_finished_amount -= 1
	if _finished_amount > 0: return
	self.hide()
	
	for i in drop.size():
		var loot = drop[i]
		_inventory_location.add_item(ResourceCollector.uid(ResourceCollector.Items, loot.data), loot.amount)
	
	if drop.size() > 0:
		_inventory_repository.insert(_inventory_location.get_entity())
	
	Questify.update_quests()
	emit_signal("finished")
