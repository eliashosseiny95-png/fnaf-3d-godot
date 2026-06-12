extends Control

class_name GameUI

var game_manager: Node
var power_label: Label
var night_label: Label
var time_label: Label

func _ready() -> void:
    game_manager = get_tree().get_first_node_in_group("game_manager")
    setup_labels()

func _process(delta: float) -> void:
    if game_manager:
        update_display()

func setup_labels() -> void:
    power_label = Label.new()
    night_label = Label.new()
    time_label = Label.new()
    add_child(power_label)
    add_child(night_label)
    add_child(time_label)
    power_label.position = Vector2(10, 10)
    night_label.position = Vector2(10, 30)
    time_label.position = Vector2(10, 50)

func update_display() -> void:
    power_label.text = "Power: %.1f%%" % game_manager.get_power()
    night_label.text = "Night: %d/5" % game_manager.get_night()
    time_label.text = "Time: %.1fs" % game_manager.get_time_remaining()
