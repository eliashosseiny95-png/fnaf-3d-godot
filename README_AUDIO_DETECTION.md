# Horror Game - Audio Detection System

## Overview
This is a horror game mechanic where **monsters can hear your real-world sounds** through your microphone. The game uses audio input detection to make the monsters more or less threatening based on how much noise you make.

## Features

### 🎤 Audio Detection
- Captures microphone input in real-time
- Measures noise levels in decibels (dB)
- Distinguishes between silence, normal sounds, and loud noises

### 👹 Monster AI
- **IDLE**: Monsters are sleeping/calm (silence)
- **ALERT**: Monsters hear something, starting to listen (light noise)
- **HUNTING**: Monsters are hunting the player (persistent noise)
- **RUSHING**: Monsters are attacking at full speed (very loud noise)

### 📊 Real-time HUD Display
- Noise level indicator (in dB)
- Alert bar showing monster threat level
- Monster status text (CALM → DETECTED SOUND! → ALERT & LISTENING → RUSHING!)

## How It Works

### Audio Thresholds
```gdscript
silence_threshold = -40 dB  # Quiet/no sound
alert_threshold = -20 dB    # Normal talking level
danger_threshold = -10 dB   # Loud sounds
```

### Gameplay Flow
1. **Stay Silent** → Monsters remain calm
2. **Make Noise** → Monsters detect and alert
3. **Keep Making Noise** → Monsters start hunting
4. **Loud Sounds** → Monsters RUSH toward you at full speed

## Setup in VS Code + Godot

### Requirements
- Godot 4.0+
- Your system microphone enabled
- Audio input device configured in Godot

### Installation Steps

1. **Add AudioDetectionSystem to your main scene**
   ```
   - Main (Node3D)
     - AudioDetectionSystem (Node)
     - Monster (CharacterBody3D with monster_ai.gd script)
     - HUD (CanvasLayer with hud_display.gd script)
   ```

2. **Configure Godot Audio Settings**
   - Go to Project → Project Settings → Audio
   - Enable "Capture Enabled"
   - Set input device to your microphone

3. **Attach Scripts**
   - `audio_detection.gd` → AudioDetectionSystem node
   - `monster_ai.gd` → Monster node
   - `hud_display.gd` → HUD node

### Scene Setup Example (GDScript)
```gdscript
extends Node3D

func _ready():
	# Create audio detection
	var audio_system = AudioDetectionSystem.new()
	add_child(audio_system)
	audio_system.name = "AudioDetectionSystem"
	
	# Create monster
	var monster = CharacterBody3D.new()
	add_child(monster)
	var monster_script = load("res://monster_ai.gd")
	monster.set_script(monster_script)
	monster.name = "Monster"
	
	# Create HUD
	var hud = CanvasLayer.new()
	add_child(hud)
	var hud_script = load("res://hud_display.gd")
	hud.set_script(hud_script)
	hud.name = "HUD"
```

## Customization

### Adjust Monster Sensitivity
Edit audio thresholds in `audio_detection.gd`:
```gdscript
silence_threshold: float = -40.0    # Make higher = more sensitive
alert_threshold: float = -20.0      # Monsters alert sooner
danger_threshold: float = -10.0     # Threshold for rushing
```

### Change Monster Speed
Edit in `monster_ai.gd`:
```gdscript
@export var speed: float = 5.0        # Normal hunting speed
@export var rush_speed: float = 15.0  # Rushing speed
```

### Add Multiple Monsters
Simply create more `CharacterBody3D` nodes with `monster_ai.gd` script attached. Each will respond to the same audio input independently.

## Tips for Gameplay

✅ **Stay quiet to survive**
- Use voice chat only when necessary
- Cover your microphone if the game gets intense
- Silent keystrokes are your friend

⚠️ **Sounds that trigger monsters**
- Talking or coughing
- Loud typing/keyboard clicks
- Phone notifications
- Background noise

🎮 **Game Difficulty**
- Hard Mode: Lower all thresholds (monsters hear everything)
- Easy Mode: Raise all thresholds (monsters need loud sounds)
- Custom: Adjust each threshold individually

## Technical Notes

- Uses `AudioEffectCapture` for real-time audio input
- RMS (Root Mean Square) calculation for noise level
- Linear to dB conversion: `linear2db(rms)`
- Runs signal system for state changes
- Fully networked-ready (can track multiple monsters)

## Future Enhancements

- [ ] Directional audio (monsters know which direction sound came from)
- [ ] Frequency analysis (distinguish between types of sounds)
- [ ] Decaying audio sensitivity (monsters get fatigued)
- [ ] Voice recognition (react to specific words/screams)
- [ ] Network multiplayer (multiple players' audio detected)
- [ ] Procedural map with multiple spawning locations

---

**Warning**: This game requires microphone access. Your audio input will not be recorded or stored—it's only analyzed locally for noise levels. Enjoy staying silent! 🤫
