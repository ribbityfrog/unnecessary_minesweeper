@abstract class_name AWeapon
extends Node3D


@export var sight: Sight
@export var shooter: Node3D

@export var nozzle: Node3D

@export var damages: Damages
@export var cooldown := 1.5

var ammo: int = 0

var can_shoot: bool = true


signal shot


func _ready() -> void:
	if (sight == null || shooter == null):
		push_error("Sight or Shooter is not assigned in the weapon: " + str(self))


func _unhandled_input(_event: InputEvent) -> void:
	if (can_shoot and Input.is_action_just_pressed('shoot')):
		_shoot()


func _shoot() -> void:
	can_shoot = false
	emit_signal('shot')
	await get_tree().create_timer(cooldown).timeout
	can_shoot = true
