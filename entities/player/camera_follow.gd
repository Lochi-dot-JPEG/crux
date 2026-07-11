extends Camera2D

@export var target:Node2D
var target_override:Node2D
@export var SMOOTHING:float = 0
@export var XMIN:float;
@export var XMAX:float;
@export var YMIN:float;
@export var YMAX:float;

const ZOOMED_IN = Vector2(1.0,1.0)
const ZOOMED_OUT = Vector2(0.6,0.6)

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
	if Globals.talk_character == Globals.CHARACTER.NONE:
		zoom = zoom.lerp(ZOOMED_OUT, delta * 3)
	else:
		zoom = zoom.lerp(ZOOMED_IN, delta * 3)
	global_transform = lerp(global_transform, 
	target.global_transform if target_override == null 
	else target_override.global_transform, SMOOTHING)
	if (position.x > XMAX):
		position.x = XMAX
	if (position.x < XMIN):
		position.x = XMIN
	if (position.y > YMAX):
		position.y = YMAX
	if (position.y < YMIN):
		position.y = YMIN
