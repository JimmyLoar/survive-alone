extends MarginContainer

@onready var name_label: Label = %NameLabel
@onready var search_display: MarginContainer = %SearchDisplay
@onready var search_button: Button = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Search

var _drop_data: SearchDrop

func _ready() -> void:
	Game.player_changed_location.connect(_update)


func _update():
	var location : WorldObject = Game.get_player_location()
	if not location or location.is_looted:
		search_display.hide()
		return
	
	var data: StructureData = location.data
	name_label.text = "%s" % data.visible_name
	_drop_data = data.search_drop
	search_display.update(data.search_drop)
	search_button.show()


func _on_search_pressed() -> void:
	var searcher := Searcher.new()
	search_button.hide()
	search_display.start_search(searcher.search(_drop_data))
	Game.get_player_location().is_looted = true
