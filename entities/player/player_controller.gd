extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var SPEED = 300.0
@export var COLLSION_NODES : Array[Node2D]

@export_category("Animations")
@export var IDLE:String
@export var WALK:String

var interactable_npcs:Array[Node2D] = []
var can_move = true

func _ready() -> void:
	Globals.finished_dialogue.connect(_finished_dialogue)

func _finished_dialogue() -> void:
	can_move = true
	print("finsiehd dialogues")


func handle_movement():
	print(can_move)
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
		sprite.play(IDLE)

	move_and_slide()

func handle_interaction():
	if not Input.is_action_just_pressed("interact"):
		return
	for npc:Node2D in interactable_npcs:
		can_move = false
		if (npc.get_parent().is_in_group("interactables")):
				npc.get_parent().on_interact()
	interactable_npcs = []
		

func _npc_enter_interaction_area(npc:Node2D):
	if (npc in COLLSION_NODES):
		return
	interactable_npcs.append(npc)

func _npc_exit_interaction_area(npc:Node2D):
	interactable_npcs.erase(npc)

func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_interaction()
