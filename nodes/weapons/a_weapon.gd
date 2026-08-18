@abstract class_name AWeapon
extends Node3D

# @export var camera: Camera3D = null

signal shot

# func _ready() -> void:
# 	if (camera == null):
# 		camera = %PlayerCamera

func _unhandled_input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed('shoot')):
		_shoot()

# func _physics_process(_delta: float) -> void:
# 	if (camera == null):
# 		return

# 	var space_state := get_world_3d().direct_space_state
# 	var cast := PhysicsRayQueryParameters3D.create(camera.global_transform.origin, camera.global_transform.origin + -camera.global_transform.basis.z * 1000)
# 	var result := space_state.intersect_ray(cast)

func _shoot() -> void:
	emit_signal('shot')
