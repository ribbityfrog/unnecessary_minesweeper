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
var field: Array[Mine]

signal minefield_created

func _ready() -> void:
	if (mine_scene == null):
		mine_scene = preload("res://scenes/mine.tscn")
	create_minefield()

# func _process(delta: float) -> void:
# 	pass

func create_minefield() -> void:
	field = []
	var field_tmp: Array[Mine] = []

	for x in range(width):
		for y in range(height):
			var mine: Mine = mine_scene.instantiate()
			mine.minefield = self
			# connect("minefield_created", mine.mine_ready)
			mine.placed_position = Vector3((x * (1 + gap_x)) - (width * (1 + gap_x)) / 2, y * (1 + gap_y), 0)
			mine.x = x
			mine.y = y
			field.push_back(mine)
			field_tmp.push_back(mine)
			add_child(mine)

	for mine in field:
		mine.link_mines()

	for i in range(mines):
		while true:
			var index := rng.randi_range(0, field_tmp.size() - 1)
			var mine := field_tmp[index]
			if (mine.mines_around_recount() > mines_around_max):
				field_tmp.remove_at(index)
				continue
			mine.has_mine = true
			field_tmp.remove_at(index)
			break

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

	tween.tween_callback(
		func():
			var i := 0
			for mine in field:
				i += 1
				if (i % 10 == 0):
					await get_tree().process_frame
				mine.mine_ready()
			emit_signal("minefield_created")
	)

func get_mine(x: int, y: int) -> Mine:
	var index := x * height + y

	if (index >= field.size() or index < 0 or x >= width or y >= height or x < 0 or y < 0):
		return null

	return field[index]
