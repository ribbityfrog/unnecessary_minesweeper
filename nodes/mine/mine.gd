class_name Mine
extends Area3D

@export var health: Health
@export var damages: Damages

@export var bezier: BezierCurve
@export var attachment_scene: PackedScene


var target: Node3D


func _ready() -> void:
	target = get_tree().get_first_node_in_group("platform")

	await get_tree().create_timer(5).timeout
	queue_free()


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

func hit(area: Area3D) -> void:
	if ("damages" in area and area.damages is Damages):
		health.lose_health(area.damages.total())

	if (health.is_dead):
		queue_free()
