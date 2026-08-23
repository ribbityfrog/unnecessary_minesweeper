class_name WeaponHolder
extends Node3D

@export var sight: Sight
@export var shooter: Node3D

@export var weapon_default := 1
@export var weapons: Array[InventoryWeapon]

var current_weapon_index: int
var current_weapon: AWeapon


func _ready() -> void:
	spawn_weapon(weapon_default)


func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.is_action_pressed("wp_up")):
			spawn_weapon(current_weapon_index + 1)
		elif (event.is_action_pressed("wp_down")):
			spawn_weapon(current_weapon_index - 1)


func spawn_weapon(wp_index: int):
	if (wp_index < 0):
		wp_index = weapons.size() - 1
	elif (wp_index >= weapons.size()):
		wp_index = 0

	current_weapon_index = wp_index

	var wp := weapons[current_weapon_index]
	var weapon := wp.scene.instantiate()

	if (current_weapon != null):
		current_weapon.queue_free()
	current_weapon = weapon

	weapon.sight = sight
	weapon.shooter = shooter
	weapon.position = wp.placement_position
	weapon.rotation_degrees = wp.placement_rotation

	if (not wp.has_been_used):
		wp.has_been_used = true
		wp.ammo = weapon.ammo
	else:
		weapon.ammo = wp.ammo

	add_child(weapon)
