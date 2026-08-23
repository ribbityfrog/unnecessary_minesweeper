class_name Floor
extends Area3D


@export var health: Health
@export var damages: Damages

func hit(area: Area3D) -> void:
	if ("damages" in area and area.damages is Damages):
		health.lose_health(area.damages.total())
