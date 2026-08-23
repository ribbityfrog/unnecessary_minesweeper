class_name Sight
extends Node

@export var camera: Camera3D
@export var distance_max := 100.0

var current_collision: CollisionObject3D

var world: World3D


func _ready() -> void:
	if (camera == null):
		return

	world = camera.get_world_3d()


func _physics_process(_delta: float) -> void:
	if (camera == null):
		return

	var space := world.direct_space_state
	var query := PhysicsRayQueryParameters3D.create(camera.global_transform.origin, camera.global_transform.origin + (-camera.global_transform.basis.z * distance_max), Bitfield.layers_to_int([2, 4, 5, 8]))
	query.collide_with_areas = true
	var result := space.intersect_ray(query)

	if (result.is_empty() || result.collider == null):
		if (current_collision != null):
			current_collision.emit_signal("mouse_exited")
			current_collision = null
		return

	if (result.collider != null and result.collider is CollisionObject3D):
		if (current_collision != null):
			if (current_collision.get_instance_id() != result.collider.get_instance_id()):
				current_collision.emit_signal("mouse_exited")
				current_collision = result.collider
				current_collision.emit_signal("mouse_entered")
		else:
			current_collision = result.collider
			current_collision.emit_signal("mouse_entered")
