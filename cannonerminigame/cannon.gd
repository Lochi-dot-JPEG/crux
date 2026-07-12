extends Node2D
var speed = 200

var returnSpeed = 5
@onready var center = $"../../center".global_position
@onready var diff_angle: float = global_position.angle_to_point(center)

@onready var ball = preload("res://cannonerminigame/cannonball.tscn")
@onready var timer = $"../../ballTimer"
@onready var shoot_from = %ShootFrom
@onready var main_cannonthing = get_node("../..")

const TOTAL_COOLDOWN = 0.5
var until_reset = 2
var shoot_cooldown

func _ready():
	shoot_cooldown = TOTAL_COOLDOWN

func _process(_delta):
	if not main_cannonthing.visible:
		return
	rotation = clampf(rotation, -PI, PI)
	shoot_cooldown -= _delta
	var _rotate = Input.get_axis("left", "right")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		rotation += _rotate * _delta
		until_reset = 2
	else:
		reset_angle(_delta)
	if Input.is_action_just_pressed("interact") and shoot_cooldown < 0:
		print("shoots")
		shoot_cooldown = 1
		spawn_cannonball()
		timer.start()

func spawn_cannonball():
	var newball = ball.instantiate()
	get_node("..").add_child(newball)
	newball.global_position = shoot_from.global_position
	newball.rotation = self.rotation


func reset_angle(delta):
	until_reset -= delta
	#await get_tree().create_timer(2).timeout
	if until_reset < 0:
		rotation = lerp_angle(rotation, diff_angle, returnSpeed * delta)
