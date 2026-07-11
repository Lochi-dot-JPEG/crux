extends Node2D
signal addtoScore
var score = Globals.scoreCannoner
var velocity = Vector2()
func _ready():
	print("created")
	velocity.y = 200
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	check_if_despawn(position)
	
func check_if_despawn(pos):
	if pos.y == 2000:
		queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	Globals.add_cannoner()
	queue_free()
	
