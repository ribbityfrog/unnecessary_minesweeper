class_name HealthBar
extends TextureRect

var tween: Tween
var health_lost: float

@onready var mat: Material = material


func setup(health: int):
	health_lost = 0

	set_shader_total(health)
	set_shader_left(health)
	set_shader_lost(health_lost)


func lose_health(amount: int, health: int) -> void:
	health_lost += amount if health >= 0 else amount + health
	
	set_shader_left(max(health, 0))
	set_shader_lost(health_lost)

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_method(
		func(val: float):
			set_shader_lost(val)
			health_lost = val,
		health_lost, 0, 2
	)


func set_shader_param(param: String, value: float) -> void:
	mat.set_shader_parameter(param, value)

func set_shader_total(value: float) -> void:
	mat.set_shader_parameter("energy_total", value)

func set_shader_left(value: float) -> void:
	mat.set_shader_parameter("energy_left", value)

func set_shader_lost(value: float) -> void:
	mat.set_shader_parameter("energy_lost", value)
