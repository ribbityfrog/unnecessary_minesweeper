class_name Mine
extends Area3D

@export var health: Health
@export var health_label: HealthLabel
@export var geometry: CSGBox3D
@export var mines_count_label: Label3D

var placed_position: Vector3 = Vector3.ZERO

var x: int
var y: int

var minefield: Minefield

var has_mine: bool = false
var is_destroyed: bool = false
var mines_around_count: int = 0
var mines_around: Dictionary[String, Mine] = {
	"tl": null,
	"t": null,
	"tr": null,
	"l": null,
	"r": null,
	"bl": null,
	"b": null,
	"br": null
}


# signal damaged(damages: Damages)
# signal died(x: int, y: int)


func _ready() -> void:
	if (minefield == null):
		minefield = get_parent() as Minefield


func mine_ready() -> void:
	health_label.edit_text(health.health)
	mines_around_recount(true)
	geometry.material = geometry.material.duplicate()
	if (has_mine):
		geometry.material.albedo_color = Color.ORANGE_RED


func link_mines() -> void:
	mines_around["tl"] = minefield.get_mine(x - 1, y + 1)
	mines_around["t"] = minefield.get_mine(x, y + 1)
	mines_around["tr"] = minefield.get_mine(x + 1, y + 1)
	mines_around["l"] = minefield.get_mine(x - 1, y)
	mines_around["r"] = minefield.get_mine(x + 1, y)
	mines_around["bl"] = minefield.get_mine(x - 1, y - 1)
	mines_around["b"] = minefield.get_mine(x, y - 1)
	mines_around["br"] = minefield.get_mine(x + 1, y - 1)


func mines_around_recount(finalized: bool = false) -> int:
	var count := 0
	for mine in mines_around.values():
		if (mine != null and mine.has_mine):
			count += 1
	mines_around_count = count

	if (finalized):
		mines_count_label.text = str(count) if count > 0 else ""

	return count


func hit(area: Area3D) -> void:
	if (area.damages is Damages):
		apply_damages(area.damages)


func apply_damages(damages: Damages) -> void:
	health.lose_health(damages.total())

	if (health.is_dead):
		damages.target_died()
		destroy()


func destroy(delayed: float = 0.0) -> void:
	if (is_destroyed):
		return
	is_destroyed = true

	if (delayed > 0.0):
		await get_tree().create_timer(delayed).timeout

	if (mines_around_count == 0 and not has_mine):
		for mine in mines_around.values():
			if (mine != null && not mine.is_destroyed):
				mine.destroy(0.15)

	geometry.queue_free()
	health_label.queue_free()
