class_name AWeapon
extends Node3D

signal shot

func _unhandled_input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed('shoot')):
		emit_signal('shot')