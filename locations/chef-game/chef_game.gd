extends Control

@onready var dialogue_node : Control = get_tree().get_first_node_in_group("dialogue")

func _ready() -> void:
	#Globals.._show_dialogue_line()

	await dialogue_node.finished_dialogue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
