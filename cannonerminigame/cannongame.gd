extends Control

func _ready():
	var timer = Timer.new()
	timer.wait_time = 1
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timeout)

func _on_timeout():
	var target = preload("res://cannonerminigame/cannon_target.tscn").instantiate()
	target.position.y = 700
	target.position.x = range(941, 767)
