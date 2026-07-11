extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var SPEED = 300.0
@export var COLLSION_NODES : Array[Node2D]

@export_category("Animations")
@export var IDLE:String
@export var WALK:String
@export var TALK:String
@onready var area :Area2D= %Area2D

var interactable_npcs:Array[Node2D] = []
var can_move = true

@onready var timer = Timer.new()
func _ready() -> void:
	add_child(timer)
	timer.wait_time = 2
	timer.one_shot = false
	timer.timeout.connect(_rescan_finished)
	timer.start()
	Globals.freeze_player.connect(_freeze)
	Globals.unfreeze_player.connect(_unfreeze)
	Globals.finished_dialogue.connect(_finished_dialogue)
	Globals.mark_character.emit(Globals.CHARACTER.NONE)
	await get_tree().create_timer(0.2).timeout
	Globals.dialogue_played.emit("intro")


func _rescan_finished():
	print("rescanned finished")
	var confirmed = 0
	if Globals.loaded_save.won_chef:
		confirmed += 1
	if Globals.loaded_save.won_sous_chef:
		confirmed += 1
	if Globals.loaded_save.won_cannoneer:
		confirmed += 1
	if Globals.loaded_save.won_medic:
		confirmed += 1
	print("confirmed " + str(confirmed))
	if confirmed == 4:
		var dialogue = get_tree().get_first_node_in_group("dialogue")
		if dialogue and dialogue.visible:
			return
		if not Globals.won:
			Globals.dialogue_played.emit("good-ending")
			Globals.won = true
			await Globals.finished_dialogue
			get_tree().quit()









func _freeze() -> void:
	can_move = false


func _unfreeze() -> void:
	can_move = true


func _finished_dialogue() -> void:
	can_move = true


func handle_movement():
	if not can_move:
		return
	var direction := Input.get_vector("left", "right", "up", "down")
	if Globals.camera.override_target != null:
		pass
	if direction:
		sprite.play(WALK)
		velocity.x = direction.x * SPEED
		if direction.x:
			if direction.x > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if Globals.talk_character == Globals.CHARACTER.YOU:
			sprite.play(TALK)
		else:
			sprite.play(IDLE)

	move_and_slide()

func handle_interaction():
	if not Input.is_action_just_pressed("interact"):
		return
	for npc:Node2D in interactable_npcs:
		if (npc.get_parent().is_in_group("interactables")):
				npc.get_parent().on_interact()
	interactable_npcs = []

func _npc_enter_interaction_area(npc:Node2D):
	if (npc in COLLSION_NODES):
		return
	if (npc == self):
		return
	interactable_npcs.append(npc)
	_update_marks()


func _npc_exit_interaction_area(npc:Node2D):
	interactable_npcs.erase(npc)
	_update_marks()

func _update_marks():
	if interactable_npcs.is_empty():
		Globals.mark_character.emit(Globals.CHARACTER.NONE)
	else:
		var found = false
		for i in interactable_npcs:
			var npc = i.get_node("..")
			if (npc.is_in_group("characters")):
				Globals.mark_character.emit(npc.npcEnum)
				print("emits mark characters")
				found = true
				break

		if not found:
			Globals.mark_character.emit(Globals.CHARACTER.NONE)


func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_interaction()
