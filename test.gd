extends Node3D


@export var follower: Node3D

var points: Array[Vector3] = [
	Vector3(-8, 7, 10),
	Vector3(0, 0, 10),
	Vector3(8, 7, 10),
]

var t: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta

	follower.global_position = Bezier.curve_3d(points, t, 5.0)
