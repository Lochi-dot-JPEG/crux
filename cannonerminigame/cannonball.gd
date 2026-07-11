extends Node2D
var velocity = 200

func _process(_delta):
	var direction = Vector2.UP.rotated(rotation)
	global_position += direction * velocity * _delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	self.queue_free()
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	self.queue_free()
