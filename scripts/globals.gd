extends Node


# Preload assets and store globally accessible variables here
# This script is accessible anywhere in the project under the Globals autoload
var high_score = 100
var score = 0
var loaded_settings : SettingsFile
var loaded_save : SaveFile
var dialogue_player = false

var won = false
# Configure the template
const MAIN_SCENE_FILE = "res://locations/placeholder/placeholder.tscn"
const GAME_TITLE = "Lost Treasure Fever"

signal dialogue_played(file)
signal switch_scene(packed_scene : PackedScene)
signal finished_dialogue
signal unfreeze_player
signal freeze_player
signal changed_talker
signal mark_character(character : CHARACTER)
signal complete_task(character : CHARACTER)

var talk_character : CHARACTER = CHARACTER.NONE:
	set(value):
		talk_character = value
		changed_talker.emit()
var talk_thinking = false

var camera: Camera2D

var scoreCannoner = 0

enum CHARACTER {
	YOU,
	CHEF,
	MEDIC,
	CANNONEER,
	SOUSCHEF,
	NAVIGATOR,
	NONE,
}

const KEYWORD_QUESTIONS = {
	"ship name":"What is your ship called?",
	"you":"You are captain of the ship. What does your crew call you?",
	"chef":"What is your head chef's name?",
	"cochef":"What is the sous-chef's name?",
	"medic":"What is the name of your medic?",
	"cannon":"What is the name of your cannoneer?",
	"best soup type":"What is your favourite type of soup? ([your answer] soup)",
	"positive descriptor":"What adjective do you call things that you find cool?",
	"container":"What will you cook your soup in?",
	"ing1":"",
	"ing2":"",
	"not so miracle cure":"What does this shabby medic put on everything that never works?",
	"treasure":"What did you leave behind?",
	"treasure location":"Where did you leave the treasure at?"
}

const CHARACTER_TO_SPRITEFRAMES = {
	CHARACTER.CHEF:preload("res://sprites/chef.tres"),
	CHARACTER.SOUSCHEF:preload("res://sprites/sous.tres"),
	CHARACTER.CANNONEER:preload("res://sprites/cannon.tres"),
	CHARACTER.MEDIC:preload("res://sprites/medic.tres"),
	CHARACTER.NAVIGATOR:preload("res://sprites/nav.tres"),
}

const CHARACTER_TO_ROLE = {
	CHARACTER.YOU:"Captain",
	CHARACTER.CHEF:"Chef",
	CHARACTER.SOUSCHEF:"Sous-Chef",
	CHARACTER.CANNONEER:"Cannoneer",
	CHARACTER.MEDIC:"Medic",
	CHARACTER.NAVIGATOR:"Navigator",
}

const NAMES_TO_CHARACTER = {
	"you":CHARACTER.YOU,
	"chef":CHARACTER.CHEF,
	"cochef":CHARACTER.SOUSCHEF,
	"medic":CHARACTER.MEDIC,
	"cannon":CHARACTER.CANNONEER,
	"nav":CHARACTER.NAVIGATOR,
}

const CHARACTER_TO_DIALOGUE_KEYWORD = {
	"[you]": CHARACTER.YOU,
	"[chef]": CHARACTER.CHEF,
	"[cochef]": CHARACTER.SOUSCHEF,
	"[cannon]": CHARACTER.CANNONEER,
	"[medic]": CHARACTER.MEDIC,
	"[nav]": CHARACTER.NAVIGATOR
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

func add_cannoner():
	scoreCannoner += 1
