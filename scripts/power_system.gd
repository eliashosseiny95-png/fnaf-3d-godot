extends Node

class_name PowerSystem

var power: float = 100.0
var systems_active: Dictionary = {"lights": true, "cameras": true, "doors": true, "ventilation": true}
var drain_rates: Dictionary = {"lights": 0.03, "cameras": 0.05, "doors": 0.08, "ventilation": 0.01}

func _ready() -> void:
    print("Power system initialized at 100%")

func _process(delta: float) -> void:
    var total_drain: float = 0.0
    for system in systems_active:
        if systems_active[system]:
            total_drain += drain_rates[system]
    power = max(0, power - total_drain * delta)

func toggle_system(system: String) -> void:
    if system in systems_active:
        systems_active[system] = !systems_active[system]
        print("%s %s" % [system.to_upper(), "ON" if systems_active[system] else "OFF"])

func get_power() -> float:
    return power

func is_active(system: String) -> bool:
    return systems_active.get(system, false)
