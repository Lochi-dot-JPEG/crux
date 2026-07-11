extends Control

@onready var button1 = %Button
@onready var button2 = %Button2
@onready var question = %Question
@onready var label = %Label

var chosen = ""
signal choice_made

func _ready() -> void:
	button1.pressed.connect(Callable(_pressed_button).bind(button1))
	button2.pressed.connect(Callable(_pressed_button).bind(button2))

func _start():
	Globals.freeze_player.emit()
	question.hide()
	Globals.dialogue_played.emit("chef-part1")
	await Globals.finished_dialogue
	await _ask_question("What should go in the pot?", "Chocolate", "Onion")
	Globals.loaded_save.keywords["[ing1]"] = chosen
	if chosen == "Chocolate":
		Globals.loaded_save.won_chef = SaveFile.WIN_STATES.WON
	if chosen == "Onion":
		Globals.loaded_save.won_sous_chef = SaveFile.WIN_STATES.WON

	Globals.dialogue_played.emit("chef-part2")
	await Globals.finished_dialogue
	await _ask_question("What should go in the pot?", "Banana", "Chicken stock")
	Globals.loaded_save.keywords["[ing2]"] = chosen

	if chosen == "Chicken stock":
		Globals.loaded_save.won_sous_chef = SaveFile.WIN_STATES.WON
	if chosen == "Banana":
		Globals.loaded_save.won_chef = SaveFile.WIN_STATES.WON

	Globals.dialogue_played.emit("chef-part3")
	await Globals.finished_dialogue

	if Globals.loaded_save.won_chef == SaveFile.WIN_STATES.WON:
		Globals.dialogue_played.emit("win-chef")
		await Globals.finished_dialogue
	if Globals.loaded_save.won_sous_chef == SaveFile.WIN_STATES.WON:
		Globals.dialogue_played.emit("win-sous-chef")
		await Globals.finished_dialogue

	Globals.unfreeze_player.emit()


func _pressed_button(choice : Button):
	chosen = choice.text
	choice_made.emit()


func _ask_question(question_text, opt1, opt2):
	question.show()
	label.text = question_text
	button1.text = opt1
	button2.text = opt2
	await choice_made
	question.hide()
	return
