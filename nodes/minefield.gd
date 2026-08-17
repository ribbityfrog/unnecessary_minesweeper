class_name Minefield
extends Node3D

@export var width: int = 10
@export var height: int = 10
@export var gap_x: float = 0.2
@export var gap_y: float = 0.2

@export var player: Node3D

var rng = RandomNumberGenerator.new()
var field: Array[Mine]

func _ready() -> void:
	create_minefield()

# func _process(delta: float) -> void:
# 	pass

func create_minefield() -> void:
	field = []
	var mineScene = preload("res://scenes/mine.tscn")

	for x in range(width):
		for y in range(height):
			var mine: Mine = mineScene.instantiate()
			mine.placed_position = Vector3((x * (1 + gap_x)) - (width * (1 + gap_x)) / 2, y * (1 + gap_y), 0)
			field.push_back(mine)
			add_child(mine)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	for mine in field:
		tween.tween_property(mine, "position", Vector3(mine.position.x + rng.randf_range(-10, 10), mine.position.y, mine.position.z + rng.randf_range(-10, 10)), 1)
		tween.tween_property(mine, "rotation_degrees", Vector3(rng.randf_range(0, 90), rng.randf_range(0, 90), rng.randf_range(0, 90)), 1)
	tween.chain()
	tween.set_trans(Tween.TRANS_ELASTIC)
	for mine in field:
		tween.tween_property(mine, "position", mine.placed_position, 2)
		tween.tween_property(mine, "rotation_degrees", Vector3(0, 0, 0), 2)

func get_mine(x: int, y: int) -> Mine:
	var index := y * width + x

	if (index >= field.size() or index < 0 or x >= width or y >= height or x < 0 or y < 0):
		return null

	return field[index]
