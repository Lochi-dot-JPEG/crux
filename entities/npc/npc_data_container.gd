extends Node2D

@export var npcEnum : Globals.CHARACTER
@export var npcAnimatedSprite : AnimatedSprite2D

func update_sprite():
	match npcEnum:
		Globals.CHARACTER.CHEF:
			pass
		Globals.CHARACTER.SOUSCHEF:
			pass
