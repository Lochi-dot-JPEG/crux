extends Control

@onready var dialogue_node : Control = get_tree().get_first_node_in_group("dialogue")

func _ready() -> void:
	#Globals.._show_dialogue_line()

<<<<<<< Updated upstream
	await dialogue_node.finished_dialogue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
=======
func _start():
	question.hide()
	Globals.dialogue_played.emit("chef-part1")
	await Globals.finished_dialogue
	await _ask_question("What should go in the pot?", "Chocolate", "Onion")
	Globals.loaded_save.keywords["[ing1]"] = chosen
	if chosen == "Chocolate":
		Globals.loaded_save.won_sous_chef = SaveFile.WIN_STATES.WON
	if chosen == "Onion":
		Globals.loaded_save.won_chef = SaveFile.WIN_STATES.WON

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
>>>>>>> Stashed changes
