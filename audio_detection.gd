extends Node

# Audio detection system - monsters can hear player sounds
class_name AudioDetectionSystem

# Audio thresholds
var silence_threshold: float = -40.0  # dB
var alert_threshold: float = -20.0    # dB
var danger_threshold: float = -10.0   # dB

# Audio input
var audio_stream_player: AudioStreamPlayer
var audio_effect_capture: AudioEffectCapture
var audio_bus: String = "Master"

# Monster hearing state
var current_noise_level: float = 0.0
var monsters_alerted: bool = false
var monster_distance_multiplier: float = 1.0

func _ready():
	setup_audio_detection()

func setup_audio_detection():
	# Create audio bus with capture effect
	var master_bus_idx = AudioServer.get_bus_index(audio_bus)
	
	if master_bus_idx == -1:
		return
	
	audio_effect_capture = AudioEffectCapture.new()
	AudioServer.add_bus_effect(master_bus_idx, audio_effect_capture)

func _process(_delta):
	if audio_effect_capture:
		update_noise_level()
		check_monster_detection()

func update_noise_level():
	# Get audio frame data
	var frame = audio_effect_capture.get_buffer(2048)
	
	if frame.is_empty():
		return
	
	# Calculate RMS (Root Mean Square) for noise level
	var sum: float = 0.0
	for sample in frame:
		sum += sample * sample
	
	var rms = sqrt(sum / frame.size())
	current_noise_level = linear2db(rms + 0.0001)  # Add small value to avoid log(0)

func check_monster_detection():
	var previous_alert_state = monsters_alerted
	
	if current_noise_level > danger_threshold:
		# DANGER! Monsters are very alert and rushing
		monsters_alerted = true
		emit_signal("danger_level_reached", current_noise_level)
	elif current_noise_level > alert_threshold:
		# Monsters are alert and listening
		monsters_alerted = true
		emit_signal("monster_alert", current_noise_level)
	else:
		monsters_alerted = false
	
	# State changed
	if previous_alert_state != monsters_alerted:
		if monsters_alerted:
			emit_signal("monster_detected_sound")
		else:
			emit_signal("monster_calm")

func get_noise_level() -> float:
	return current_noise_level

func are_monsters_alerted() -> bool:
	return monsters_alerted

func get_alert_percentage() -> float:
	# Normalize noise level to 0-100%
	var range_db = danger_threshold - silence_threshold
	var clamped = clamp(current_noise_level, silence_threshold, danger_threshold)
	return ((clamped - silence_threshold) / range_db) * 100.0

# Signals
signal monster_detected_sound
signal monster_calm
signal monster_alert(noise_level: float)
signal danger_level_reached(noise_level: float)
