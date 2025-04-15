extends TextureRect

var data: ItemNumberTuple


func _ready():
	texture = data.item.texture
	$Label.text = 'x' + str(data.amount) if data.amount != 1 else ''


func setup(_data: ItemNumberTuple):
	data = _data
