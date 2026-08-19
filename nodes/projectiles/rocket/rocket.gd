class_name Rocket
extends Area3D

@export var launch_offset := 2.0
@export var launch_duration := 0.4
@export var speed := 20.0

var damages: Damages
var origin: Node3D

var is_launched: bool = false


func _ready() -> void:
	if (origin == null):
		queue_free()
		return

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "global_position", origin.global_position + -origin.global_transform.basis.z * launch_offset, launch_duration)
	tween.parallel().tween_property(self, "global_rotation", origin.global_rotation, launch_duration)
	tween.tween_callback(
		func():
			is_launched = true
			await get_tree().create_timer(5).timeout
			destroy()
	)

func _physics_process(delta: float) -> void:
	if (is_launched):
		translate(Vector3.FORWARD * speed * delta)

func destroy(_body: Node = null) -> void:
	queue_free()
