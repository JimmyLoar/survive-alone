extends MarginContainer


@onready var title: Label = %TitleLabel
@onready var discription: RichTextLabel = %Discription


func _ready():
	Questify.quest_objective_completed.connect(_display)


func _display(quest: QuestResource):
	title.text = quest.name
	discription.clear()
	discription.text = "[color=yellow]%s[/color]" % quest.description
	discription.newline()
	discription.append_text("=".repeat(71))
	discription.newline()
	
	var objectives = quest.get_active_objectives()
	if quest.completed:
		var end_index = quest.nodes.find_custom(func(node): return node is QuestEnd)
		objectives = quest.get_previous_nodes(quest.nodes[end_index])
	
	_diplay_objective_text(objectives)
	# TODO Сделать показ подсказок при нажатии на мета-ссылку


func _diplay_objective_text(objectives: Array):
	for i in objectives.size():
		var objecte := objectives[i] as QuestObjective
		discription.append_text("[p]%s" % [objecte.description])
		discription.newline()
		if objectives.size() > 1 and i < objectives.size() - 1:
			discription.newline()
			var string = TranslationServer.translate("KEY_CAPS_AND_WORD")
			if objecte.next.any(func(node): return node is QuestExclusiveBranchConnector):
				string = TranslationServer.translate("KEY_CAPS_OR_WORD")
			var repeat_value = ceil((73 - string.length()) / 2.0)
			discription.append_text("%s%s%s" % [
				"-".repeat(repeat_value),
				string,
				"-".repeat(repeat_value)
			])
			discription.newline()


func _on_objective_discription_meta_clicked(_meta: Variant) -> void:
	print(_meta)


func _on_objective_discription_meta_hover_started(_meta: Variant) -> void:
	pass # Replace with function body.
