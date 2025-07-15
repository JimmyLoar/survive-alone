class_name GameOver
extends MarginContainer

enum Reason{
	EXHAUSTION_FULL,
}


const REASON_DEATH_TEXT = {
	Reason.EXHAUSTION_FULL: "DEATH_EXHAUSTION_FULL",
}

const  REASON_HINTS = {
	Reason.EXHAUSTION_FULL: ["SURVIVE_HINT_EXHAUSTION_FULL"],
}


enum {
	Bandits,
	Survivor,
	Merchants,
}

const CONTEXT_TEXTS = {
	Bandits:	"LOSE_CONTEXT_BANDITS",
	Survivor:	"LOSE_CONTEXT_SURVIVOR",
	Merchants:	"LOSE_CONTEXT_MERCHANTS",
}


@export var _title_label: Label
@export var _reasen_label: Label
@export var _context_label: RichTextLabel
@export var _hints_label: RichTextLabel
@export var _continue_button: Button
@export var _menu_button: Button

@onready var texture_rect: TextureRect = $PanelBG/TextureRect


func _ready() -> void:
	_continue_button.pressed.connect(_on_pressed_continue)
	_menu_button.pressed.connect(_on_pressed_menu)


func open(_reason: Reason):
	await ready
	_title_label.text = TranslationServer.translate("LOSE_TITLE")
	_reasen_label.text = TranslationServer.translate(REASON_DEATH_TEXT[_reason])
	set_hints(REASON_HINTS[_reason])


func set_hints(hints: PackedStringArray):
	_hints_label.clear()
	for hint in hints:
		_hints_label.append_text(hint)
		_hints_label.newline()


func update_context():
	_context_label.clear()
	_context_label.append_text(TranslationServer.translate(
		CONTEXT_TEXTS[randi_range(Bandits, Merchants + 1)]
	))


func _on_pressed_continue():
	var game := Locator.get_service(GameState) as GameState
	# TODO Добавить штрафы
	
	
	Locator.get_service(ExhaustionLooker).active = false
	Locator.get_service(GameTimeState).do_step(7*1440)
	Locator.get_service(ExhaustionLooker).active = true
	restore_props_on_continue()
	game.open_world_screen(
		ProjectSettings.get_setting("databases/game_database_path"), 
		ProjectSettings.get_setting("databases/save_database_path"),
	)

func restore_props_on_continue():
	var cs: CharacterState = Locator.get_service(CharacterState)
	var hunger = cs.get_property('hunger')
	hunger.value = 70
	cs.set_property(hunger)
	var exhaustion = cs.get_property('exhaustion')
	exhaustion.value = 10
	cs.set_property(exhaustion)
	var thirst = cs.get_property('thirst')
	thirst.value = 70
	cs.set_property(thirst)

func _on_pressed_menu():
	var game := Locator.get_service(GameState) as GameState
	get_tree().quit()
