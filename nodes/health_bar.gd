class_name HealthBar
extends TextureRect

var tween: Tween
var health_lost: float

@onready var mat: Material = material

func setup(health: int):
	health_lost = 0

	mat.set_shader_parameter("energy_total", health)
	mat.set_shader_parameter("energy_left", health)
	mat.set_shader_parameter("energy_lost", health_lost)


func lose_health(amount: int, health: int) -> void:
	health_lost += amount if health >= 0 else amount + health
	
	mat.set_shader_parameter("energy_left", max(health, 0))
	mat.set_shader_parameter("energy_lost", health_lost)

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_method(
		func(val: float):
			mat.set_shader_parameter("energy_lost", val)
			health_lost = val,
		health_lost, 0, 2
	)
