extends Node3D

var current_night: int = 1
var power_level: float = 100.0
var time_elapsed: float = 0.0
var game_active: bool = false

const NIGHT_DURATION: float = 300.0
const POWER_DRAIN_RATE: float = 0.2

func _ready() -> void:
    add_to_group("game_manager")
    start_night()

func _process(delta: float) -> void:
    if game_active:
        time_elapsed += delta
        power_level = max(0, power_level - POWER_DRAIN_RATE * delta)
        if power_level == 0:
            power_out()
        elif time_elapsed >= NIGHT_DURATION:
            night_complete()

func start_night() -> void:
    game_active = true
    time_elapsed = 0.0
    power_level = 100.0
    print("Night %d started" % current_night)

func night_complete() -> void:
    game_active = false
    current_night += 1
    if current_night <= 5:
        await get_tree().create_timer(2.0).timeout
        start_night()
    else:
        print("YOU WIN!")

func power_out() -> void:
    game_active = false
    print("POWER OUT!")

func get_night() -> int:
    return current_night

func get_power() -> float:
    return power_level

func get_time_remaining() -> float:
    return max(0, NIGHT_DURATION - time_elapsed)
