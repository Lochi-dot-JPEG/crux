extends Control

@onready var name_label : Label = %Name
@onready var text_label : RichTextLabel = %Line
@onready var question_box : Control = %QuestionBox
@onready var question_label : Label = %Question
@onready var text_edit : TextEdit = %TextEdit
@onready var confirm_button : Button = %Confirm

var keyword_regex = RegEx.create_from_string("\\[([^\\]]*)\\]")

var loaded_lines : Array[DialogueLine] = []
var current_line : int = 0

func _ready() -> void:
	Globals.dialogue_played.connect(_load_dialogue)
	


func _next_line() -> void:
	current_line += 1
	if current_line >= loaded_lines.size():
		loaded_lines = []
		hide()
		Globals.dialogue_target_camera(Globals.CHARACTER.YOU)
		Globals.finished_dialogue.emit()
		return
	_show_dialogue_line(current_line)


func _show_dialogue_line(line_number : int):
	var _line : DialogueLine = loaded_lines[line_number]
	Globals.dialogue_target_camera(_line.character)
	show()
	# TODO load animation here
	var character_name = await _get_character_name(_line.character)
	var converted_text = await _substitute_keywords(_line.text)
	text_label.text = converted_text
	name_label.text = character_name


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if not question_box.visible and event.is_action_pressed("next_dialogue"):
		_next_line()


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


func _ensure_name_exists(character : Globals.CHARACTER):
	if character not in Globals.loaded_save.character_names.keys():
		var character_role_name = Globals.CHARACTER_TO_ROLE[character]

		var valid_find = false
		_show_question("What is your " + character_role_name + "'s name?")
		while not valid_find:
			await confirm_button.pressed
			if text_edit.text != "":
				valid_find = true
			# TODO confirm if they really want this name
		Globals.loaded_save.character_names[character] = text_edit.text
		question_box.hide()


func _show_question(question : String):
	question_box.show()
	text_edit.text = ""
	text_edit.grab_focus()
	text_edit.placeholder_text = ""
	question_label.text = question


func _substitute_keywords(text) -> String:
	var regexed_keywords = keyword_regex.search_all(text)
	for result in regexed_keywords:
		if result.strings[0] not in Globals.CHARACTER_TO_DIALOGUE_KEYWORD.keys():
			await _ensure_keyword_exists(result.strings[0])

	var converted_text = text

	for character_key in Globals.CHARACTER_TO_DIALOGUE_KEYWORD.keys():
		var character = Globals.CHARACTER_TO_DIALOGUE_KEYWORD[character_key]
		if Globals.loaded_save.character_names.keys().has(character):
			print("has character " + str(character))
			var converted_name = Globals.loaded_save.character_names[character]
			converted_text = converted_text.replace(character_key, "[color=purple]"+ converted_name + "[/color]")

	for key in Globals.loaded_save.keywords.keys():
		converted_text = converted_text.replace(key, "[color=red]"+ Globals.loaded_save.keywords[key] + "[/color]")
	
	return converted_text


func _get_character_name(character : Globals.CHARACTER) -> String:
	await _ensure_name_exists(character)
	return Globals.loaded_save.character_names[character]


func _load_dialogue(file : String) -> void:
	if loaded_lines != []:
		return
	loaded_lines = DialogueLine._load_dialogue_file(file)
	current_line = -1
	_next_line()


func _on_text_edit_text_changed() -> void:
	if text_edit.text.find("\n") != -1:
		text_edit.text = text_edit.text.replace("\n", "")
		text_edit.set_caret_column(text_edit.text.length())
		confirm_button.pressed.emit()
