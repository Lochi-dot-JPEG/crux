extends Node2D

@onready var timer = $targetTimer
var target = preload("res://cannonerminigame/cannon_target.tscn")

func _start():
	Globals.freeze_player.emit()
	show()
	timer.wait_time = 3
	timer.start()
	await timer.timeout
	
func spawn_new():
	var targetNew = target.instantiate()
	targetNew.position.x = randf_range(0, 700)
	add_child(targetNew)

func _process(_delta):
	print("checks")
	print(Globals.scoreCannoner)
	if Globals.scoreCannoner >= 5:
		Globals.loaded_save.won_cannoneer = SaveFile.WIN_STATES.WON
		Globals.dialogue_played.emit("win-cannoneer")
		queue_free()

