extends Node3D

class_name CameraSystem

var cameras: Dictionary = {}
var current_camera: String = "main_hall"

var camera_feeds: Dictionary = {
    "main_hall": Vector3(0, 2, -5),
    "east_wing": Vector3(5, 2, 0),
    "west_wing": Vector3(-5, 2, 0),
    "kitchen": Vector3(0, 2, 5),
    "office": Vector3(0, 1.5, 0)
}

func _ready() -> void:
    setup_cameras()

func _process(delta: float) -> void:
    handle_input()

func setup_cameras() -> void:
    for cam_name in camera_feeds:
        cameras[cam_name] = camera_feeds[cam_name]
    print("Cameras initialized")

func handle_input() -> void:
    if Input.is_action_just_pressed("ui_1"):
        switch_camera("main_hall")
    elif Input.is_action_just_pressed("ui_2"):
        switch_camera("east_wing")
    elif Input.is_action_just_pressed("ui_3"):
        switch_camera("west_wing")
    elif Input.is_action_just_pressed("ui_4"):
        switch_camera("kitchen")
    elif Input.is_action_just_pressed("ui_5"):
        switch_camera("office")

func switch_camera(cam_name: String) -> void:
    if cam_name in cameras:
        current_camera = cam_name
        print("Switched to: %s" % cam_name)

func get_current_camera() -> String:
    return current_camera
