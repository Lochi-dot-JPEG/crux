extends Node2D
var speed = 200

var returnSpeed = 5
var center = $center.global_position
var diff_angle: float = global_position.angle_to_point(center)

@onready var ball = preload("res://cannonerminigame/cannonball.tscn")
@onready var timer = $"../../ballTimer"

func _ready():
	timer.wait_time = 0.5
	timer.start()

func _process(_delta):
	rotation = clampf(rotation, -PI, PI)
	var rotate = Input.get_axis("left", "right")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_angle(rotate, _delta)
	else:
		reset_angle(_delta)
	if Input.is_action_pressed("interact") and timer.is_stopped():
		spawn_cannonball()
		timer.start()

func spawn_cannonball():
	var newball = ball.instantiate()
	newball.position = global_position
	newball.rotation = self.rotation
	get_tree().current_scene.add_child(newball)
	 

func change_angle(rotate, _delta):
	if Input.is_action_pressed("left"):
		rotation += rotate * _delta
	if Input.is_action_pressed("right"):
		rotation += rotate * _delta

func reset_angle(_delta):
	await get_tree().create_timer(2).timeout
	rotation = lerp_angle(rotation, diff_angle, returnSpeed * _delta)
