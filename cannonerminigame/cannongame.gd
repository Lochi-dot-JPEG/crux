extends Node2D

@onready var timer = $targetTimer
var target = preload("res://cannonerminigame/cannon_target.tscn")
var score = Globals.scoreCannoner
func _ready():
	timer.wait_time = 5
	timer.start()
	await timer.timeout
	
func spawn_new():
	var targetNew = target.instantiate()
	targetNew.position.x = randf_range(0, 700)
	add_child(targetNew)

func _process(_delta):
	if score >= 5:
		pass
		#return to main ,,,, ?
