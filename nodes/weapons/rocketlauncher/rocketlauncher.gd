class_name RocketLauncher
extends AWeapon

@export var rocket: PackedScene = null
@export var tip: Node3D = null

var root: Window

func _ready() -> void:
	root = get_tree().root

func _shoot() -> void:
	var rocket_instance: Rocket = rocket.instantiate()
	rocket_instance.global_transform = tip.global_transform
	rocket_instance.origin = %PlayerCamera
	rocket_instance.rotation = global_rotation
	root.add_child(rocket_instance)
	super._shoot()
