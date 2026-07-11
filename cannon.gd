extends Node2D
var speed = 200

var returnSpeed = 5
var center = $center.global_position
var diff_angle: float = global_position.angle_to_point(center)

func _process(_delta):
	var rotate = Input.get_axis("left", "right")
	if Input.is_anything_pressed():
		change_angle(rotate, _delta)
	else:
		reset_angle(_delta)

func change_angle(rotate, _delta):
	if Input.is_action_pressed("left"):
		print("turn left by ", rotate)
		rotation += rotate * _delta
	if Input.is_action_pressed("right"):
		print("turn right by ", rotate)
		rotation += rotate * _delta
	
func reset_angle(_delta):
	print("resetting . . .")
	await get_tree().create_timer(2).timeout
	rotation = lerp_angle(rotation, diff_angle, returnSpeed * _delta)
