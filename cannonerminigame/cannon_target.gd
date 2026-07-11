extends Node2D

var velocity = Vector2()

func _ready():
	print("created")
	velocity.y = 200
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	check_if_despawn(position)
	
func check_if_despawn(pos):
	if pos.y == 2000:
		self.queue_free()
