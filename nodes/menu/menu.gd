class_name Menu
extends Node3D


var selected_difficulty: MenuDifficulty


signal started


func select_difficulty(difficulty: MenuDifficulty) -> void:
	if (difficulty != selected_difficulty && difficulty != null):
		if (selected_difficulty != null):
			selected_difficulty.deselect()
		selected_difficulty = difficulty


func start_game() -> void:
	emit_signal("started")
