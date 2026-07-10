extends Control

@onready var title_label : Label = %TitleLabel
@onready var play_button : Button = %Play
@onready var settings_button : Button = %Settings
@onready var quit_button : Button = %Quit

func _ready() -> void:
	title_label.text = Globals.GAME_TITLE
	if OS.get_name() == "Web":
		quit_button.hide()
		quit_button.queue_free()
	else:
		quit_button.pressed.connect(get_tree().quit)

	play_button.pressed.connect(_play)
	settings_button.pressed.connect(_settings)

func _play() -> void:
	get_tree().change_scene_to_file(Globals.MAIN_SCENE_FILE)

func _settings() -> void:
	pass
