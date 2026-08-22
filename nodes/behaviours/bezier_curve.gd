class_name BezierCurve
extends Node


@export var time_to_target := 1.0
@export var stop_at_target: bool
@export var autostart: bool

@export var follower: Node3D

@export var children_as_points: Node3D

@export_group("Custom points")
@export var points_relative_to_follower: bool
@export var points: Array[Vector3]

var is_started := false
var is_target_reached := false

var time_elapsed := 0.0


signal started
signal target_reached(target_position: Vector3)


func _ready() -> void:
	if not follower:
		follower = get_parent()
	
	if not follower is Node3D:
		push_error("BezierCurve: follower must be a Node3D.")

	if children_as_points:
		var new_points = children_as_points.get_children().filter(func(c): return c is Node3D).map(func(c): return c.global_position)
		points.clear()
		for point in new_points:
			points.append(point)
	elif points_relative_to_follower:
		var new_points = points.map(func(p: Vector3): return follower.global_transform.origin + p)
		points.clear()
		for point in new_points:
			points.append(point)

	if autostart:
		start()


func _process(delta: float) -> void:
	if not is_started or (stop_at_target and is_target_reached):
		return

	time_elapsed += delta
	follower.global_position = Bezier.curve_3d(points, time_elapsed, time_to_target)

	if not is_target_reached and time_elapsed >= time_to_target:
		is_target_reached = true
		emit_signal("target_reached", points[points.size() - 1])
		
		if stop_at_target:
			is_started = false


func start() -> void:
	if not follower:
		push_error("BezierCurve: follower is not set.")
		return

	if points.size() < 3 or points.size() > 4:
		push_error("BezierCurve: points array must have 3 or 4 points.")
		return

	emit_signal("started")
	is_started = true
