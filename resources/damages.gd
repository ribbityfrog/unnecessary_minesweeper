class_name Damages
extends Resource

@export var impact: int = 50

@export_group("Burns")
@export var burns: int = 0
@export var burns_decay: int = 0
@export var burns_spread: int = 0

@export_group("Explodes")
@export var explodes: int = 0
@export var explodes_decay: int = 0
@export var explodes_spread: int = 0

func total() -> int:
    return impact + burns + explodes

func is_spreadable() -> bool:
    return (burns_spread > 0 and burns > 0) or (explodes_spread > 0 and explodes > 0)

func target_died() -> void:
    burns = 0
    burns_spread = 0

func decay() -> void:
    impact = 0

    if (burns > 0 && burns_spread > 0):
        burns -= burns_decay
        burns_spread -= 1
        if (burns < 0):
            burns = 0

    if (explodes > 0 && explodes_spread > 0):
        explodes -= explodes_decay
        explodes_spread -= 1
        if (explodes < 0):
            explodes = 0
