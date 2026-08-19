class_name HealthLabel
extends Label3D

var font_size_default: int
@export var font_size_bigger := 112
@export var font_size_speed := 0.2

func _ready() -> void:
	font_size_default = font_size

func edit_text(new_text: int) -> void:
	text = str(new_text)

func size_bigger() -> void:
	var tween := create_tween()
	tween.tween_property(self, "font_size", font_size_bigger, font_size_speed)

func size_default() -> void:
	var tween := create_tween()
	tween.tween_property(self, "font_size", font_size_default, font_size_speed)
