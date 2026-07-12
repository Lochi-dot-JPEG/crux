extends Node2D

@export var npcEnum : Globals.CHARACTER
@export var npcAnimatedSprite : AnimatedSprite2D
@onready var talk_marker : AnimatedSprite2D = %Talkking

func _ready() -> void:
	add_to_group("characters")
	Globals.changed_talker.connect(_animate)
	Globals.mark_character.connect(update_marker)
	update_sprite()


func update_marker(marker : Globals.CHARACTER):
	talk_marker.visible = marker == npcEnum


func update_sprite():
	npcAnimatedSprite.sprite_frames = Globals.CHARACTER_TO_SPRITEFRAMES[npcEnum]
	npcAnimatedSprite.play("idle")

func _animate():
	if Globals.talk_character == npcEnum:
		if Globals.talk_thinking and npcAnimatedSprite.sprite_frames.has_animation("thinktalk"):
			npcAnimatedSprite.play("thinktalk")
		else:
			npcAnimatedSprite.play("talk")
	else:
		npcAnimatedSprite.play("idle")
	var player = get_tree().get_first_node_in_group("player")
	if player:
		npcAnimatedSprite.flip_h = player.global_position.x < global_position.x


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
			await Globals.finished_dialogue
			var cannon_game = get_tree().get_first_node_in_group("cannongame")
			cannon_game._start()
		Globals.CHARACTER.YOU:
			Globals.dialogue_played.emit("test")
		Globals.CHARACTER.NAVIGATOR:
			Globals.dialogue_played.emit("nav-intro")
