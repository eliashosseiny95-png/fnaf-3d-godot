extends CharacterBody3D

# Monster AI - responds to player audio
class_name MonsterAI

@export var monster_name: String = "Shadow Creature"
@export var speed: float = 5.0
@export var detection_range: float = 50.0
@export var rush_speed: float = 15.0

# References
@onready var audio_detection: AudioDetectionSystem
var player: Node3D

# Monster state
enum MonsterState { IDLE, ALERT, HUNTING, RUSHING }
var current_state: MonsterState = MonsterState.IDLE
var previous_state: MonsterState = MonsterState.IDLE

# Audio influence
var audio_influence: float = 0.0
var alert_timer: float = 0.0
var alert_duration: float = 3.0

func _ready():
	# Find audio detection system in scene
	audio_detection = get_tree().root.get_child(0).find_child("AudioDetectionSystem", true, false)
	player = get_tree().get_first_child_in_group("player")
	
	if audio_detection:
		audio_detection.monster_detected_sound.connect(_on_monster_hearing_sound)
		audio_detection.monster_alert.connect(_on_monster_alert)
		audio_detection.danger_level_reached.connect(_on_danger_reached)

func _process(delta):
	update_monster_state(delta)
	update_monster_behavior(delta)

func update_monster_state(delta: float):
	previous_state = current_state
	
	if not audio_detection:
		return
	
	var noise_level = audio_detection.get_noise_level()
	var alert_percent = audio_detection.get_alert_percentage()
	
	# State transitions based on audio
	match current_state:
		MonsterState.IDLE:
			if audio_detection.are_monsters_alerted():
				current_state = MonsterState.ALERT
				alert_timer = alert_duration
		
		MonsterState.ALERT:
			alert_timer -= delta
			if audio_detection.current_noise_level > audio_detection.danger_threshold:
				current_state = MonsterState.RUSHING
			elif alert_timer <= 0 and not audio_detection.are_monsters_alerted():
				current_state = MonsterState.IDLE
		
		MonsterState.HUNTING:
			if audio_detection.are_monsters_alerted():
				current_state = MonsterState.RUSHING
			elif not can_see_player():
				current_state = MonsterState.IDLE
		
		MonsterState.RUSHING:
			if not audio_detection.are_monsters_alerted():
				alert_timer = alert_duration
				current_state = MonsterState.HUNTING
	
	# State changed - log it
	if previous_state != current_state:
		print_debug("%s state changed: %s -> %s" % [monster_name, MonsterState.keys()[previous_state], MonsterState.keys()[current_state]])

func update_monster_behavior(delta: float):
	match current_state:
		MonsterState.IDLE:
			pass  # Stay still
		
		MonsterState.ALERT:
			# Look around, listening intensely
			rotate_y(deg_to_rad(30 * delta))
		
		MonsterState.HUNTING:
			if player and can_see_player():
				move_towards_target(player.global_position, speed, delta)
		
		MonsterState.RUSHING:
			if player:
				move_towards_target(player.global_position, rush_speed, delta)

func move_towards_target(target_pos: Vector3, move_speed: float, delta: float):
	var direction = (target_pos - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func can_see_player() -> bool:
	if not player:
		return false
	
	var distance = global_position.distance_to(player.global_position)
	return distance < detection_range

func _on_monster_hearing_sound():
	print_debug("%s HEARD A SOUND!" % monster_name)

func _on_monster_alert(noise_level: float):
	alert_timer = alert_duration
	print_debug("%s is alert! Noise level: %.2f dB" % [monster_name, noise_level])

func _on_danger_reached(noise_level: float):
	print_debug("%s DETECTED LOUD NOISE! RUSHING! (%.2f dB)" % [monster_name, noise_level])
	current_state = MonsterState.RUSHING

func get_current_state_name() -> String:
	return MonsterState.keys()[current_state]
