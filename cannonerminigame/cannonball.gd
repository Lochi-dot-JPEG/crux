extends Node2D
var velocity = 200


func _process(_delta):
	var direction = Vector2.UP.rotated(rotation)
	global_position += direction * velocity * _delta
