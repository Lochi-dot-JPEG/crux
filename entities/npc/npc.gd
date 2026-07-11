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
	match npcEnum:
		Globals.CHARACTER.SOUSCHEF:
			Globals.dialogue_played.emit("souschef-warning")
		Globals.CHARACTER.CHEF:
			Globals.dialogue_played.emit("chef-intro")
			await Globals.finished_dialogue
			var chef_game = get_tree().get_first_node_in_group("chefgame")
			chef_game.show()
			chef_game._start()

		Globals.CHARACTER.MEDIC:
			var medic_game = get_tree().get_first_node_in_group("medicgame")
			medic_game._start()
		Globals.CHARACTER.CANNONEER:
			Globals.dialogue_played.emit("cannon-intro")
		Globals.CHARACTER.YOU:
			Globals.dialogue_played.emit("test")
