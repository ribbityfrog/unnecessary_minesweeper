class_name Finger
extends AWeapon

func _shoot() -> void:
	if (sight.current_collision != null && sight.current_collision.has_method('select')):
		sight.current_collision.select()
	super._shoot()
