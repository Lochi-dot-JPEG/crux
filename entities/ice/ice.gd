extends Area2D

const MOVE_SPEED = 200


func _physics_process(delta: float) -> void:
	position.y += delta * MOVE_SPEED
	if global_position.y > 800:
		queue_free()
