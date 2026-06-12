extends Node3D

func _ready() -> void:
    setup_scene()
    create_animatronics()

func setup_scene() -> void:
    var light = DirectionalLight3D.new()
    light.position = Vector3(0, 10, 0)
    add_child(light)
    var floor = CSGBox3D.new()
    floor.size = Vector3(20, 0.1, 20)
    floor.position.y = -5
    add_child(floor)
    create_wall(Vector3(10, 3, 0), Vector3(0.1, 6, 20))
    create_wall(Vector3(-10, 3, 0), Vector3(0.1, 6, 20))
    create_wall(Vector3(0, 3, 10), Vector3(20, 6, 0.1))
    create_wall(Vector3(0, 3, -10), Vector3(20, 6, 0.1))
    print("Office created")

func create_wall(pos: Vector3, size: Vector3) -> void:
    var wall = CSGBox3D.new()
    wall.position = pos
    wall.size = size
    add_child(wall)

func create_animatronics() -> void:
    var freddy = create_animatronic("Freddy", Vector3(-5, 0, 5))
    var bonnie = create_animatronic("Bonnie", Vector3(5, 0, 5))
    var chica = create_animatronic("Chica", Vector3(0, 0, 8))
    var foxy = create_animatronic("Foxy", Vector3(-8, 0, 8))
    print("Animatronics created")

func create_animatronic(name: String, pos: Vector3) -> Animatronic:
    var anim = Animatronic.new()
    anim.position = pos
    anim.anim_name = name
    add_child(anim)
    return anim
