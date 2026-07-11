extends Node2D

const ICE_SCENE = preload("res://entities/ice/ice.tscn")
const HEAL_SCENE = preload("res://entities/heals/heals.tscn")
const LEFT = 410
const RIGHT = 747
const PLAYER_SPEED = 300
const ICE_COOLDOWN = 2
const HEAL_COOLDOWN = 0.5

var heal_timer = 0
var ice_timer = 0
var patient_health = 0

@export var player : Area2D
@onready var health : ProgressBar = %ProgressBar
@onready var timer : Timer = %GameTime
@onready var time_label : Label = %TimeLabel

func _ready() -> void:
	heal_timer = HEAL_COOLDOWN
	ice_timer = ICE_COOLDOWN
	player.area_entered.connect(_player_area_entered)
	player.position.x = (LEFT + RIGHT)  / 2.0
	process_mode = Node.PROCESS_MODE_DISABLED

func _start():
	if patient_health >= 98 or Globals.loaded_save.won_medic == SaveFile.WIN_STATES.WON:
		_finished()
		print("early finish")
		return

	Globals.dialogue_played.emit("medic-intro")
	await Globals.finished_dialogue
	show()
	Globals.freeze_player.emit()
	process_mode = Node.PROCESS_MODE_INHERIT
	timer.wait_time = 30
	timer.start()
	await timer.timeout

	_finished()

func _finished():
	if Globals.loaded_save.won_medic == SaveFile.WIN_STATES.UNDETERMINED:
		Globals.loaded_save.won_medic = SaveFile.WIN_STATES.LOST
	elif Globals.loaded_save.won_medic == SaveFile.WIN_STATES.WON:
		Globals.dialogue_played.emit("win-medic")
		await Globals.finished_dialogue
	hide()
	Globals.unfreeze_player.emit()
	process_mode = Node.PROCESS_MODE_DISABLED

func _player_area_entered(area):
	if area.is_in_group("hurts"):
		patient_health -= 30
		patient_health = clamp(patient_health, 0, 1000)
		area.queue_free()
	elif area.is_in_group("heals"):
		patient_health += 30
		area.queue_free()


func _create_ice() -> void:
	var new_ice = HEAL_SCENE.instantiate()
	new_ice.position.x = randf_range(LEFT,RIGHT)
	add_child(new_ice)


func _create_heal() -> void:
	var new_heal = ICE_SCENE.instantiate()
	new_heal.position.x = randf_range(LEFT,RIGHT)
	add_child(new_heal)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		player.position.x = clampf(player.position.x - delta * PLAYER_SPEED, LEFT, RIGHT)
	if Input.is_action_pressed("right"):
		player.position.x = clampf(player.position.x + delta * PLAYER_SPEED, LEFT, RIGHT)

	if patient_health >= 98:
		Globals.loaded_save.won_medic = SaveFile.WIN_STATES.WON
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
		_finished()

	health.value = patient_health

	heal_timer -= delta
	time_label.text = str(round(timer.time_left))
	while heal_timer <= 0:
		_create_heal()
		heal_timer += HEAL_COOLDOWN

	ice_timer -= delta
	while ice_timer <= 0:
		_create_ice()
		ice_timer += ICE_COOLDOWN
