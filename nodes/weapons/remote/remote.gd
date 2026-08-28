class_name Remote
extends AWeapon

func _shoot() -> void:
	if (sight.current_collision != null && sight.current_collision.has_method('metallized')):
		sight.current_collision.metallized()
	super._shoot()
