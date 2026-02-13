extends CharacterBody3D

@onready var state_machine = $StateMachine

@export var walk_speed: float = 4.0
@export var run_speed: float = 9.0
const gravity: float = 9.8

func _ready() -> void:
	state_machine.initialize(self)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)

	var input_dir = get_input_direction()

	# La FSM decide estado, dirección y velocidad
	var movement_velocity = state_machine.process(input_dir, walk_speed, run_speed)

	velocity.x = movement_velocity.x
	velocity.z = movement_velocity.z

	move_and_slide()


func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("D") - Input.get_action_strength("A"),
		Input.get_action_strength("S") - Input.get_action_strength("W")
	)


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
