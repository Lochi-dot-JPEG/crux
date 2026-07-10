class_name DialogueLine
extends Resource

@export var character : Globals.Character
@export var line : String
@export var animation : String

static func _load_dialogue(name) -> Array[DialogueLine]:
	var loaded_csv = load("dialogue/" + name + ".csv")
	var lines : Array[DialogueLine] = []
	for line in loaded_csv:
		var instance = DialogueLine.new()
		#instance.name = line[0]
		instance.line = line[2]
		lines.append(instance)

	return [instance]
