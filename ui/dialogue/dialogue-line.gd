class_name DialogueLine
extends Resource

@export var character : Globals.CHARACTER
@export var text : String
@export var animation : String

static func _load_dialogue_file(name : String) -> Array[DialogueLine]:
	var loaded_csv = load("dialogue/" + name + ".csv")
	var lines : Array[DialogueLine] = []
	for line in loaded_csv.records:
		if line[0] == "":
			continue
		var instance = DialogueLine.new()
		instance.character = Globals.NAMES_TO_CHARACTER[line[0]]
		instance.animation = line[1]
		instance.text = line[2]
		lines.append(instance)
	return lines
