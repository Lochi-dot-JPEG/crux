extends Control

enum CHARACTER {
	YOU,
	CHEF,
	SOUSCHEF,
}

@onready var name_label : Label = %Name
@onready var text_label : RichTextLabel = %Line

@onready var question_box : Control = %QuestionBox
@onready var question_label : Label = %Question
@onready var text_edit : TextEdit = %TextEdit
@onready var confirm_button : Button = %Confirm

var keyword_regex = RegEx.create_from_string("\\[([^\\]]*)\\]")

func _ready() -> void:
	_show_dialogue_line(CHARACTER.YOU,"This is a [vegetable] test [second regexed keyword] dialogue line")

func _show_dialogue_line(character : CHARACTER, text : String):
	show()
	var converted_text = await _substitute_keywords(text)
	print(converted_text)
	var character_name = _get_character_name(character)
	text_label.text = converted_text
	name_label.text = character_name

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if not question_box.visible and event.is_action_pressed("next_dialogue"):
		hide()

func _ensure_keyword_exists(keyword_id : String):
	if keyword_id not in Globals.loaded_save.keywords.keys():
		var valid_find = false
		_show_question("What word captures the crux of " + str(keyword_id)) # TODO dont just use ids
		while not valid_find:
			await confirm_button.pressed
			if text_edit.text != "":
				valid_find = true
			# TODO confirm if they really want this word
		Globals.loaded_save.keywords[keyword_id] = text_edit.text
		question_box.hide()

func _show_question(question : String):
	question_box.show()
	text_edit.text = ""
	question_label.text = question

func _substitute_keywords(text) -> String:
	var regexed_keywords = keyword_regex.search_all(text)
	for result in regexed_keywords:
		await _ensure_keyword_exists(result.strings[0])

	var converted_text = text

	for key in Globals.loaded_save.keywords.keys():
		print("key is " + key)
		converted_text = converted_text.replace(key, "[color=yellow]"+ Globals.loaded_save.keywords[key] + "[/color]")
	
	return converted_text # TODO


func _get_character_name(character : CHARACTER) -> String:
	return "Their name" # TODO
