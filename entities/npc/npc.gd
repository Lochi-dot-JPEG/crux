extends Node2D

@export var npcEnum : Globals.CHARACTER
@export var npcAnimatedSprite : AnimatedSprite2D

func _ready() -> void:
	add_to_group("characters")

func update_sprite():
	match npcEnum:
		Globals.CHARACTER.CHEF:
			pass
		Globals.CHARACTER.SOUSCHEF:
			pass

func on_interact():
	Globals.dialogue_played.emit("test")
	match npcEnum:
		Globals.CHARACTER.CHEF:
			# TODO use globals to show dialogue
			pass
