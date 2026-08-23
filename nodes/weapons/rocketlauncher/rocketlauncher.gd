class_name RocketLauncher
extends AWeapon


@export var rocket: PackedScene

var root: Window


func _ready() -> void:
	root = get_tree().root


func _shoot() -> void:
	var rocket_instance: Rocket = rocket.instantiate()
	rocket_instance.damages = damages.duplicate()
	rocket_instance.global_transform = nozzle.global_transform
	rocket_instance.rotation = global_rotation
	rocket_instance.origin = %PlayerCamera
	root.add_child(rocket_instance)
	super._shoot()
