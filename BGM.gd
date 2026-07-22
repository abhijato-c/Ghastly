extends Node

var Background: AudioStreamPlayer
var Effects: AudioStreamPlayer

func _ready() -> void:
	Background = AudioStreamPlayer.new()
	Background.bus = "BGM"
	add_child(Background)

func PlayTrack(Track: AudioStream) -> void:
	if Background.stream == Track:
		return
	
	Background.stream = Track
	Background.play()

func Play() -> void:
	Background.play()

func Pause() -> void:
	Background.stop()

func UpdateVolume() -> void:
	Background.volume_linear = Globals.Config["Master Volume"] * Globals.Config["Background Music"] / 100

func PlayEffect(Track: AudioStream):
	Effects.volume_linear = Globals.Config["Master Volume"] * Globals.Config["Sound Effects"] / 100
	Effects.stream = Track
	Effects.play()
