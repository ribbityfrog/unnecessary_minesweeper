class_name Deagle
extends AWeapon

func _shoot() -> void:
	if (sight.current_collision != null && sight.current_collision.has_method('apply_damages')):
		sight.current_collision.apply_damages(damages)
	super._shoot()
