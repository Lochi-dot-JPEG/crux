extends Control

@export var task_message:String
@export var task_icon:Texture2D
@export var task_character:Globals.CHARACTER


@export var icon:TextureRect
@export var message:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	message.text = task_message
	icon.texture = task_icon
	Globals.complete_task.connect(try_mark_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func mark_completed() -> void:
	self.hide()
	

func try_mark_completed(char:Globals.CHARACTER):
	if char == task_character:
		mark_completed()
