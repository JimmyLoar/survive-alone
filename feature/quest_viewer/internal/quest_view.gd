extends VBoxContainer


@onready var title: Label = $TitleLabel
@onready var text_label: RichTextLabel = $RichTextLabel


func _display(quest: QuestResource):
	title.text = quest.name
	text_label.clear()
	text_label.append_text(quest.description)
