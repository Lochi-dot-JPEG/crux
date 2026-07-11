extends Node2D
@export var speed = 100

var center = $center.global_position

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
