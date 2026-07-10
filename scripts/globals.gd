extends Node


# Preload assets and store globally accessible variables here
# This script is accessible anywhere in the project under the Globals autoload
var high_score = 100
var score = 0
var loaded_settings : SettingsFile
var loaded_save : SaveFile

# Configure the template
const MAIN_SCENE_FILE = "res://ui/main/main.tscn"
const GAME_TITLE = "Your Game Title"

enum CHARACTER {
	YOU,
	CHEF,
	SOUSCHEF,
}

const NAMES_TO_CHARACTER = {
	"you":CHARACTER.YOU,
	"chef":CHARACTER.CHEF,
	"cochef":CHARACTER.SOUSCHEF,
}
