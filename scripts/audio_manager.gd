extends Node

class_name AudioManager

var audio_players: Dictionary = {}

func _ready() -> void:
    create_audio_players()

func create_audio_players() -> void:
    var ambient = AudioStreamPlayer.new()
    var sfx = AudioStreamPlayer.new()
    var music = AudioStreamPlayer.new()
    add_child(ambient)
    add_child(sfx)
    add_child(music)
    audio_players["ambient"] = ambient
    audio_players["sfx"] = sfx
    audio_players["music"] = music
    print("Audio system initialized")

func play_sound(type: String, sound_path: String) -> void:
    if type in audio_players:
        var player = audio_players[type]
        if ResourceLoader.exists(sound_path):
            var stream = load(sound_path)
            player.stream = stream
            player.play()

func play_jumpscare() -> void:
    print("JUMPSCARE SOUND!")
