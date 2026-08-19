class_name Mine
extends Area3D

@export var health: Health
var placed_position: Vector3 = Vector3.ZERO

var x: int
var y: int

signal damaged(damages: Damages)
signal died(x: int, y: int)

func _ready() -> void:
    if (health == null):
        health = %Health

func mine_ready() -> void:
    health.propagate()

func hit(area: Area3D) -> void:
    if (area.damages is Damages):
        apply_damages(area.damages)

func apply_damages(damages: Damages) -> void:
    health.lose_health(damages.total())

    if (health.is_dead):
        damages.target_died()
        emit_signal("died", x, y)

    if (damages.is_spreadable()):
        damages.decay()
        emit_signal("damaged", damages)

func destroy() -> void:
    queue_free()
