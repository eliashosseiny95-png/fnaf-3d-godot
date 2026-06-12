extends CanvasLayer

# HUD Display - shows noise level and monster status
class_name HUDDisplay

@onready var audio_detection: AudioDetectionSystem
@onready var noise_label: Label
@onready var alert_bar: ProgressBar
@onready var monster_status_label: Label

func _ready():
	# Create UI elements
	setup_ui()
	
	# Find audio detection system
	audio_detection = get_tree().root.get_child(0).find_child("AudioDetectionSystem", true, false)
	
	if audio_detection:
		audio_detection.monster_detected_sound.connect(_on_sound_detected)
		audio_detection.monster_calm.connect(_on_monster_calm)
		audio_detection.monster_alert.connect(_on_monster_alert)

func setup_ui():
	# Noise level label
	noise_label = Label.new()
	noise_label.text = "NOISE: -60 dB"
	noise_label.add_theme_font_size_override("font_size", 24)
	add_child(noise_label)
	
	# Alert progress bar
	alert_bar = ProgressBar.new()
	alert_bar.min_value = 0
	alert_bar.max_value = 100
	alert_bar.value = 0
	alert_bar.custom_minimum_size = Vector2(300, 30)
	alert_bar.position = Vector2(10, 50)
	add_child(alert_bar)
	
	# Monster status label
	monster_status_label = Label.new()
	monster_status_label.text = "MONSTERS: CALM"
	monster_status_label.add_theme_font_size_override("font_size", 20)
	monster_status_label.position = Vector2(10, 100)
	add_child(monster_status_label)

func _process(_delta):
	if audio_detection:
		update_display()

func update_display():
	# Update noise level display
	var noise_db = audio_detection.get_noise_level()
	noise_label.text = "NOISE: %.1f dB" % noise_db
	
	# Update alert bar
	var alert_percent = audio_detection.get_alert_percentage()
	alert_bar.value = alert_percent
	
	# Change bar color based on threat level
	if alert_percent < 30:
		alert_bar.modulate = Color.GREEN
	elif alert_percent < 70:
		alert_bar.modulate = Color.YELLOW
	else:
		alert_bar.modulate = Color.RED

func _on_sound_detected():
	monster_status_label.text = "MONSTERS: DETECTED SOUND!"
	monster_status_label.modulate = Color.ORANGE

func _on_monster_calm():
	monster_status_label.text = "MONSTERS: CALM"
	monster_status_label.modulate = Color.GREEN

func _on_monster_alert(_noise_level: float):
	monster_status_label.text = "MONSTERS: ALERT & LISTENING"
	monster_status_label.modulate = Color.YELLOW
