class_name Player
extends CharacterBody3D

@export var camera: Camera3D

@export_group('Movements')
@export var speed_rotation := 0.2
@export var speed_walk := 7.0
@export var speed_run := 10.0
@export var friction := 0.8

@export_group('Jump')
@export var gravity := -9.1
@export var jump_force := 5.0
@export var jump_min_ratio := 0.35

var mouse_relative := Vector2.ZERO

var is_jumping := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (camera == null):
		camera = %PlayerCamera


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * speed_rotation
		camera.rotation_degrees.x = clamp(
				camera.rotation_degrees.x - (event.relative.y * speed_rotation),
				-80.0, 80.0
			)

func _physics_process(delta_time: float) -> void:
	velocity = Vector3(velocity.x * friction, velocity.y, velocity.z * friction)

	if (not is_on_floor()):
		velocity.y += gravity * delta_time
	elif (Input.is_action_just_pressed('jump')):
		velocity.y = jump_force
		is_jumping = true
	if (is_jumping and Input.is_action_just_released('jump')):
		is_jumping = false
		if (velocity.y > jump_force * jump_min_ratio):
			velocity.y = jump_force * jump_min_ratio

	var speed_mvt := speed_run if Input.is_action_pressed('shift') else speed_walk

	var direction := Input.get_vector('left', 'right', 'forward', 'backward')
	if (direction != Vector2.ZERO):
		var mvt := global_transform.basis * Vector3(direction.x, 0, direction.y) * speed_mvt
		velocity.x = mvt.x
		velocity.z = mvt.z

	move_and_slide()
