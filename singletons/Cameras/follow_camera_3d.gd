extends Camera3D

@export var target_path: NodePath
@export var smooth_speed: float = 0.0
@export var use_smoothing: bool = false

var target: Node3D
var last_target_position: Vector3

func _ready():
	if target_path:
		target = get_node(target_path)

	if target:
		last_target_position = target.global_position


func _process(delta):
	if not target:
		return

	var movement = target.global_position - last_target_position
	var new_position = global_position + movement

	if use_smoothing:
		global_position = global_position.lerp(new_position, smooth_speed * delta)
	else:
		global_position = new_position

	last_target_position = target.global_position


func reset_tracking():
	if target:
		last_target_position = target.global_position
