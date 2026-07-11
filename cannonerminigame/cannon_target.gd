extends Node2D

func _process(_delta):
	position.y += 700 * _delta
	check_if_despawn(position.y)
	
func check_if_despawn(pos):
	if pos.y >= 700:
		self.queue_free()
