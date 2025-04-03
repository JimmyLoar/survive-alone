extends MarginContainer


@onready var title: Label = %TitleLabel
@onready var discription: RichTextLabel = %Discription


func _ready():
	pass


func _display(quest: QuestResource):
	title.text = quest.name
	discription.clear()
	discription.text = "[color=yellow]%s[/color]" % quest.description
	discription.newline()
	discription.append_text("-".repeat(discription.get_character_line(32)))
	discription.newline()
	
	var objectives := quest.get_active_objectives()
	for i in objectives.size():
		var objecte := objectives[i]
		discription.append_text("[p]%s" % [objecte.description])
		discription.newline()
		if objectives.size() > 1 and i < objectives.size() - 1:
			discription.newline()
			discription.append_text("[center]-----ИЛИ-----[/center]")
			discription.newline()


func _on_objective_discription_meta_clicked(meta: Variant) -> void:
	print(meta)


func _on_objective_discription_meta_hover_started(meta: Variant) -> void:
	pass # Replace with function body.
