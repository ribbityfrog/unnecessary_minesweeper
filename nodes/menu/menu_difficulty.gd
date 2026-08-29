class_name MenuDifficulty
extends Area3D

@export var geometry: CSGBox3D

@export var is_selected := false

@export_group("Game configuration")
@export var width: int
@export var height: int
@export var mines: int

@export_group("Selection colors")
@export var default_color: Color
@export var hovered_color: Color
@export var selected_color: Color

var material: StandardMaterial3D


signal selected(difficulty: MenuDifficulty)


func _ready() -> void:
	material = geometry.material

	if (is_selected):
		emit_signal("selected", self)
		color_tween(selected_color)


func start() -> void:
	emit_signal("selected", self)


func select() -> void:
	if not is_selected:
		emit_signal("selected", self)
		is_selected = true
		color_tween(selected_color)


func deselect() -> void:
	is_selected = false
	color_tween(default_color)


func hover() -> void:
	if not is_selected:
		color_tween(hovered_color)


func unhover() -> void:
	if not is_selected:
		color_tween(default_color)


func color_tween(color: Color) -> void:
	var tween = create_tween()
	tween.set_ease(tween.EASE_IN_OUT)
	tween.set_trans(tween.TRANS_CIRC)
	tween.tween_property(material, "albedo_color", color, 0.2)
