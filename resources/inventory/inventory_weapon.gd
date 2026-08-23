class_name InventoryWeapon
extends Resource

@export var name: String
@export var scene: PackedScene

@export_group("Switch")
@export var away_speed := 0.15
@export var away_transition := Tween.TRANS_CUBIC
@export var draw_speed := 0.15
@export var draw_transition := Tween.TRANS_BACK

@export_group("Placement")
@export var placement_position: Vector3 = Vector3.ZERO
@export var placement_rotation: Vector3 = Vector3.ZERO

@export_group("States")
@export var ammo: int = 0
@export var has_been_used: bool = false