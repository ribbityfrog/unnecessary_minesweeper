class_name Kickback
extends Node

@export var item: Node3D

@export var kb_position: Vector3 = Vector3.ZERO
@export var kb_rotation: Vector3 = Vector3.ZERO
@export var kick_speed: float = 0.5
@export var back_speed: float = 1.5

var orig_position: Vector3
var orig_rotation: Vector3

func _ready() -> void:
	if item == null:
		item = get_parent()
	orig_position = item.position
	orig_rotation = item.rotation_degrees

func kickback() -> void:
	var tween := create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_EXPO)
	tween.tween_property(item, "position", kb_position + orig_position, kick_speed)
	tween.parallel().tween_property(item, "rotation_degrees", kb_rotation + orig_rotation, kick_speed)
	tween.set_trans(tween.TRANS_BACK)
	tween.tween_property(item, "position", orig_position, back_speed)
	tween.parallel().tween_property(item, "rotation_degrees", orig_rotation, back_speed)
