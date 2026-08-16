class_name Mine
extends RigidBody3D

@export var placed_duration: float = 2

var placed_position: Vector3 = Vector3.ZERO

var parent: Minefield

# func _ready() -> void:
	# parent = get_parent()
	# var tween := create_tween()

	# tween.set_trans(Tween.TRANS_BACK)
	# tween.tween_property(self, "position", Vector3(position.x + parent.rng.randf_range(-10, 10), position.y, position.z + parent.rng.randf_range(-10, 10)), 1)
	# tween.set_trans(Tween.TRANS_ELASTIC)
	# tween.tween_property(self, "position", placed_position, placed_duration)
	# tween.free()


# func _process(delta: float) -> void:
# 	if (parent.player != null):
# 		look_at(parent.player.global_position)
