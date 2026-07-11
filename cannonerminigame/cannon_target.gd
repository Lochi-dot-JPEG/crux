extends Node2D

var speed = 100

func _process(_delta):
	position.y += 700 + speed * _delta
	check_if_despawn(position.y)
	
func check_if_despawn(pos):
	if pos.y == 2000:
		self.queue_free()
