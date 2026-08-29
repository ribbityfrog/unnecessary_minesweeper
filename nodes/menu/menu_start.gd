class_name MenuSelectable
extends Area3D

@export var geometry: CSGBox3D

@export_group("Selection colors")
@export var default_color: Color
@export var hovered_color: Color

var material: StandardMaterial3D


signal selected()


func _ready() -> void:
	material = geometry.material

func select() -> void:
	emit_signal("selected")

func hover() -> void:
	color_tween(hovered_color)

func unhover() -> void:
	color_tween(default_color)

func color_tween(color: Color) -> void:
	var tween = create_tween()
	tween.set_ease(tween.EASE_IN_OUT)
	tween.set_trans(tween.TRANS_CIRC)
	tween.tween_property(material, "albedo_color", color, 0.2)
