class_name RocketLauncher
extends AWeapon


@export var rocket: PackedScene

func _shoot() -> void:
	var rocket_instance: Rocket = rocket.instantiate()
	rocket_instance.damages = damages.duplicate()
	rocket_instance.global_transform = nozzle.global_transform
	rocket_instance.rotation = global_rotation
	rocket_instance.origin = shooter
	get_tree().current_scene.add_child(rocket_instance)
	super._shoot()
