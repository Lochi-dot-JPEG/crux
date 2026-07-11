extends Node


# Preload assets and store globally accessible variables here
# This script is accessible anywhere in the project under the Globals autoload
var high_score = 100
var score = 0
var loaded_settings : SettingsFile
var loaded_save : SaveFile
var dialogue_player = false

# Configure the template
const MAIN_SCENE_FILE = "res://ui/main/main.tscn"
const GAME_TITLE = "Your Game Title"

signal dialogue_played(file)
signal switch_scene(packed_scene : PackedScene)
signal finished_dialogue
signal unfreeze_player
signal freeze_player
signal changed_talker

var talk_character : CHARACTER = CHARACTER.NONE:
	set(value):
		talk_character = value
		changed_talker.emit()
var talk_thinking = false # TODO make this trigger

var camera: Camera2D


enum CHARACTER {
	YOU,
	CHEF,
	MEDIC,
	CANNONEER,
	SOUSCHEF,
	NONE,
}

const CHARACTER_TO_SPRITEFRAMES = {
	CHARACTER.CHEF:preload("res://sprites/chef.tres"),
	CHARACTER.SOUSCHEF:preload("res://sprites/sous.tres"),
	CHARACTER.CANNONEER:preload("res://sprites/cannon.tres"),
	CHARACTER.MEDIC:preload("res://sprites/medic.tres"),
}

const CHARACTER_TO_ROLE = {
	CHARACTER.YOU:"Captain",
	CHARACTER.CHEF:"Chef",
	CHARACTER.SOUSCHEF:"Sous-Chef",
	CHARACTER.CANNONEER:"Cannoneer",
	CHARACTER.MEDIC:"Medic",
}

const NAMES_TO_CHARACTER = {
	"you":CHARACTER.YOU,
	"chef":CHARACTER.CHEF,
	"cochef":CHARACTER.SOUSCHEF,
	"medic":CHARACTER.MEDIC,
	"cannon":CHARACTER.CANNONEER,
}

const CHARACTER_TO_DIALOGUE_KEYWORD = {
	"[you]": CHARACTER.YOU,
	"[chef]": CHARACTER.CHEF,
	"[cochef]": CHARACTER.SOUSCHEF,
	"[cannon]": CHARACTER.CANNONEER,
	"[medic]": CHARACTER.MEDIC,
}

const HEAL_SPRITES = [
	preload("res://sprites/items/bandaid.png"),
	preload("res://sprites/items/shot.png"),
	preload("res://sprites/items/ice.png"),
]

func dialogue_target_camera(target_character : CHARACTER):
	if target_character == CHARACTER.YOU:
		camera.reset_target()
		return
	
	var characters = get_tree().get_nodes_in_group("characters")
	for c in characters :
		if (c.npcEnum != target_character):
			continue
		camera.override_target(c)
		break
