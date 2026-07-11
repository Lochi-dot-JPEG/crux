class_name SaveFile
extends Resource

# You can edit what is stored in the save file
# Remember to give every variable a default value
@export var high_score = 100
@export var captain_name = "John"
@export var chef_name = "Head Chef"
@export var sous_chef_name = "Sous-Chef"

@export var character_names = {}
@export var keywords = {}

enum WIN_STATES {
	UNDETERMINED,
	WON,
	LOST,
}

@export var won_chef : WIN_STATES = WIN_STATES.UNDETERMINED
@export var won_sous_chef : WIN_STATES = WIN_STATES.UNDETERMINED
@export var won_cannoneer : WIN_STATES = WIN_STATES.UNDETERMINED
@export var won_medic : WIN_STATES = WIN_STATES.UNDETERMINED
