class_name Game
extends Node3D

@export var menu_scene: PackedScene
@export var minefield: Minefield
@export var player: Player

var weapon_holder: WeaponHolder
var menu: Menu


func _ready() -> void:
    weapon_holder = player.weapon_holder
    menu_create()


func launch_game() -> void:
    var diff := menu.selected_difficulty
 
    @warning_ignore("INTEGER_DIVISION")
    if (diff == null || diff.width < 3 || diff.height < 3 || diff.mines < 2 || diff.mines >= (diff.width * diff.height) / 4):
        push_error("Invalid difficulty configuration: width=%d, height=%d, mines=%d" % [diff.width, diff.height, diff.mines])
        return

    minefield.create_minefield(diff.width, diff.height, diff.mines)
    menu_destroy()
    weapon_holder.unlock_weapon()


func menu_create() -> void:
    if (menu != null):
        return

    weapon_holder.lock_weapon()

    menu = menu_scene.instantiate()
    menu.connect("started", Callable(self, "launch_game"))
    menu.position = Vector3(0, -5, 10)
    add_child(menu)

    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_BACK)
    tween.tween_property(menu, "position", Vector3(0, 1.2, 10), 2)


func menu_destroy() -> void:
    if (menu == null):
        return

    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_SPRING)
    tween.tween_property(menu, "position", Vector3(0, -5, 10), 2)
    tween.tween_callback(
        func():
            menu.queue_free()
            menu = null
    )
