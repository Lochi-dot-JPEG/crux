extends Camera2D

@export var target:Node2D
var target_override:Node2D
@export var SMOOTHING:float = 0
@export var XMIN:float;
@export var XMAX:float;
@export var YMIN:float;
@export var YMAX:float;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target == null:
		target = get_parent()
	Globals.camera = self

func override_target(target:Node2D):
	target_override = target

func reset_target():
	target_override = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform = lerp(transform, 
	target.transform if target_override == null 
	else target_override.transform, SMOOTHING)
	if (position.x > XMAX):
		position.x = XMAX
	if (position.x < XMIN):
		position.x = XMIN
	if (position.y > YMAX):
		position.y = YMAX
	if (position.y < YMIN):
		position.y = YMIN
