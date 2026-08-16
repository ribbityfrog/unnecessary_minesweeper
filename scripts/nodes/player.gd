class_name Player
extends CharacterBody3D

@export var camera: Camera3D
@export var gravity := -9.1

@export var speed_rotation := 5.0
@export var speed_mvt := 7.0
@export var friction := 0.8

var mouse_relative := Vector2.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (camera == null):
		camera = %PlayerCamera


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_relative = event.relative # .normalized() * event.relative.length()

func _physics_process(delta_time: float) -> void:
	velocity = Vector3(velocity.x * friction, velocity.y, velocity.z * friction)

	if (mouse_relative != Vector2.ZERO):
		rotation_degrees.y -= mouse_relative.x * speed_rotation * delta_time
		camera.rotation_degrees.x = clamp(
				camera.rotation_degrees.x - (mouse_relative.y * speed_rotation * delta_time),
				-80.0, 80.0
			)
		mouse_relative = Vector2.ZERO

	velocity.y += gravity * delta_time

	var direction := Input.get_vector('left', 'right', 'forward', 'backward')
	if (direction != Vector2.ZERO):
		var mvt := global_transform.basis * Vector3(direction.x, 0, direction.y) * speed_mvt
		velocity.x = mvt.x
		velocity.z = mvt.z

	move_and_slide()
