extends Area2D

const MOVE_SPEED = 200
@export var is_heal = false
@onready var rotation_speed = randf_range(PI,TAU)

func _ready() -> void:
	if is_heal:
		$Sprite2D.texture = Globals.HEAL_SPRITES.pick_random()

func _physics_process(delta: float) -> void:
	rotation += delta * rotation_speed
	position.y += delta * MOVE_SPEED
	if global_position.y > 800:
		queue_free()
