class_name Mine
extends Area3D


@export_group("Children")
@export var health: Health
@export var health_label: HealthLabel
@export var mines_count_label: Label3D
@export var geometry: CSGBox3D
@export var collision: CollisionShape3D

@export_group("Materials")
@export var material_default: StandardMaterial3D
@export var material_debug: StandardMaterial3D

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
	if (has_mine):
		geometry.material = material_debug
		mines_count_label.queue_free()
	else:
		mines_around_recount(true)


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
	if ("damages" in area and area.damages is Damages):
		apply_damages(area.damages)


func apply_damages(damages: Damages) -> void:
	if (is_destroyed):
		return

	health.lose_health(damages.total())

	if (damages.is_explodes_spreadable()):
		minefield.propagate_explosion(x, y, damages.explodes, damages.explodes_decay, damages.explodes_spread)

	if (health.is_dead):
		destroy()


func apply_explosion_damages(damages: int):
	health.lose_health(damages)

	if (health.is_dead):
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

	collision.disabled = true
	geometry.queue_free()
	health_label.queue_free()
