extends Control

enum CHARACTER {
	YOU,
	CHEF,
	SOUSCHEF,
}

@onready var name_label : Label = %Name
@onready var text_label : Label = %Line

func _ready() -> void:
	_show_dialogue_line(CHARACTER.YOU,"This is a test dialogue line")

func _show_dialogue_line(character : CHARACTER, text : String):
	show()
	var converted_text = _substitute_keywords(text)
	var character_name = _get_character_name(character)
	text_label.text = converted_text
	name_label.text = character_name

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("next_dialogue"):
		hide()

func _substitute_keywords(text) -> String:
	return text # TODO

func _get_character_name(character : CHARACTER) -> String:
	return "Their name" # TODO
