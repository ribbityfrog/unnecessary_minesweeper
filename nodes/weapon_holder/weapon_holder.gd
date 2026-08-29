class_name WeaponHolder
extends Node3D


@export var sight: Sight
@export var shooter: Node3D

@export var weapon_default := -1
@export var is_locked: bool = true
@export var weapons: Array[InventoryWeapon]

var current_weapon_index: int
var current_weapon: AWeapon


func _ready() -> void:
	current_weapon_index = fix_index(weapon_default)
	spawn_weapon()
	current_weapon.is_swapping = false


func _unhandled_input(event: InputEvent) -> void:
	if (is_locked):
		return

	if (event is InputEventMouseButton):
		if (event.is_action_pressed("wp_up")):
			switch_weapon(current_weapon_index + 1)
		elif (event.is_action_pressed("wp_down")):
			switch_weapon(current_weapon_index - 1)


func switch_weapon(wp_index: int):
	var new_index := fix_index(wp_index)

	var old_weapon := weapons[current_weapon_index]
	var new_weapon := weapons[new_index]

	current_weapon.is_swapping = true
	current_weapon_index = new_index

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(old_weapon.away_transition)
	tween.tween_property(self, "rotation_degrees", Vector3(-45, 0, 0), old_weapon.away_speed)
	tween.tween_callback(spawn_weapon)
	tween.set_trans(new_weapon.draw_transition)
	tween.tween_property(self, "rotation_degrees", Vector3(0, 0, 0), new_weapon.draw_speed)
	tween.tween_callback(func():
		current_weapon.is_swapping = false
	)


func spawn_weapon():
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


func lock_weapon(index: int = -1):
	if (is_locked):
		return

	switch_weapon(index)
	is_locked = true


func unlock_weapon(index: int = 0):
	if (not is_locked):
		return

	is_locked = false
	switch_weapon(index)


func fix_index(index: int) -> int:
	if (index < 0):
		return weapons.size() - 1
	elif (index >= weapons.size()):
		return 0
	return index
