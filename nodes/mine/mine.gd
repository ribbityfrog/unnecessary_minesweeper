class_name Mine
extends Area3D

@export var bezier: BezierCurve
@export var attachment_scene: PackedScene

var target: Node3D


func _ready() -> void:
	target = get_node("/root/game/Platform")


func start() -> void:
	if (attachment_scene != null):
		var attachment = attachment_scene.instantiate()
		get_tree().current_scene.add_child(attachment)
		attachment.global_position = global_position

	bezier.points = [
		global_position,
		global_position + Vector3((target.global_position.x - global_position.x) / 1.5, 5, (target.global_position.z - global_position.z) / 1.5),
		target.global_position
	]
	bezier.start()


func _process(_delta: float) -> void:
	if (target != null && global_position.distance_to(target.global_position) > 0.1):
		look_at(target.global_position)
