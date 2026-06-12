extends CharacterBody3D

class_name Animatronic

var anim_name: String
var aggression: float = 0.0
var location: int = 0
var game_manager: Node

func _ready() -> void:
    game_manager = get_tree().get_first_node_in_group("game_manager")
    print("%s initialized" % anim_name)

func _process(delta: float) -> void:
    if not game_manager or not game_manager.game_active:
        return
    update_aggression()
    update_location()

func update_aggression() -> void:
    aggression = float(game_manager.current_night) * 15.0
    aggression = clamp(aggression, 0, 100)

func update_location() -> void:
    if aggression < 25:
        location = 0
    elif aggression < 50:
        location = 1
    elif aggression < 75:
        location = 2
    else:
        location = 3
        trigger_jumpscare()

func trigger_jumpscare() -> void:
    print("%s JUMPSCARE!" % anim_name)

func get_status() -> Dictionary:
    return {"name": anim_name, "aggression": aggression, "location": location}
