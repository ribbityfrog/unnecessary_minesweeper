class_name Minefield
extends Node3D

@export var mine_scene: PackedScene

@export_group("Board")
@export var width := 20
@export var height := 10
@export var gap_x := 1.0
@export var gap_y := 1.0

@export_group("Mines")
@export var mines := 30
@export var mines_around_max := 5

@export var player: Node3D

var rng = RandomNumberGenerator.new()
var field: Array[Brick]

signal minefield_ready


func _ready() -> void:
	if (mine_scene == null):
		mine_scene = preload("res://scenes/brick.tscn")
	create_minefield()


func create_minefield() -> void:
	field = []
	var field_tmp: Array[Brick] = []

	for x in range(width):
		for y in range(height):
			var brick: Brick = mine_scene.instantiate()
			brick.minefield = self
			brick.placed_position = Vector3((x * (1 + gap_x)) - (width * (1 + gap_x)) / 2, y * (1 + gap_y), 0)
			brick.x = x
			brick.y = y
			field.push_back(brick)
			field_tmp.push_back(brick)
			add_child(brick)

	for brick in field:
		brick.link_mines()

	for i in range(mines):
		while true:
			var index := rng.randi_range(0, field_tmp.size() - 1)
			var brick := field_tmp[index]
			if (brick.mines_around_recount() > mines_around_max):
				field_tmp.remove_at(index)
				continue
			brick.has_mine = true
			field_tmp.remove_at(index)
			break

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	for brick in field:
		tween.tween_property(brick, "position", Vector3(brick.position.x + rng.randf_range(-10, 10), brick.position.y, brick.position.z + rng.randf_range(-10, 10)), 1)
		tween.tween_property(brick, "rotation_degrees", Vector3(rng.randf_range(0, 90), rng.randf_range(0, 90), rng.randf_range(0, 90)), 1)
	
	tween.chain()
	tween.set_trans(Tween.TRANS_ELASTIC)
	for brick in field:
		tween.tween_property(brick, "position", brick.placed_position, 2)
		tween.tween_property(brick, "rotation_degrees", Vector3(0, 0, 0), 2)

	tween.tween_callback(
		func():
			var i := 0
			for brick in field:
				i += 1
				if (i % 10 == 0):
					await get_tree().process_frame
				brick.brick_ready()
			emit_signal("minefield_ready")
	)


func get_brick(x: int, y: int) -> Brick:
	var index := x * height + y

	if (index >= field.size() or index < 0 or x >= width or y >= height or x < 0 or y < 0):
		return null

	return field[index]


func propagate_explosion(x: int, y: int, damages: int, decay: int, spread: int) -> void:
	for i in range(1, spread + 1):
		damages -= decay
		if (damages <= 0):
			break
		
		for dx in [-i, 0, i]:
			for dy in [-i, 0, i]:
				if (dx == 0 and dy == 0):
					continue

				var mine := get_brick(x + dx, y + dy)
				if (mine != null and not mine.is_destroyed):
					mine.apply_explosion_damages(damages)
