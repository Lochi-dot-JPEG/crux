extends Node2D

@onready var viewport : SubViewport = %SubViewport

func _ready() -> void:
	Globals.switch_scene.connect(_switch_scene)

func _switch_scene(scene : PackedScene):
	for child in viewport.get_children():
		child.queue_free()

	viewport.add_child(scene.instantiate())
