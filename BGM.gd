extends Node

var Background: AudioStreamPlayer
var Effects: AudioStreamPlayer
var FadeTween: Tween
var FadeTime: float = 3
var Volume: float

func _ready() -> void:
	Background = AudioStreamPlayer.new()
	Background.bus = "BGM"
	add_child(Background)
	
	Effects = AudioStreamPlayer.new()
	Effects.bus = "SFX"
	add_child(Effects)

func PlayTrack(Track: AudioStream) -> void:
	if Background.stream == Track:
		return
	
	if FadeTween and FadeTween.is_valid():
		FadeTween.kill()
	
	FadeTween = create_tween()
	if Background.playing:
		FadeTween.tween_property(Background, "volume_linear", 0.0, FadeTime)
		FadeTween.tween_callback(func():
			Background.stream = Track
			Background.play()
		)
	else:
		Background.stream = Track
		Background.volume_linear = 0.0
		Background.play()
	
	FadeTween.tween_property(Background, "volume_linear", Volume, FadeTime)

func Play() -> void:
	Background.play()

func Pause() -> void:
	Background.stop()

func UpdateVolume() -> void:
	Volume = Globals.Config["Master Volume"] * Globals.Config["Background Music"] / 100.0
	if FadeTween and FadeTween.is_valid():
		FadeTween.kill()
	Background.volume_linear = Volume

func PlayEffect(Track: AudioStream):
	Effects.volume_linear = Globals.Config["Master Volume"] * Globals.Config["Sound Effects"] / 100.0
	Effects.stream = Track
	Effects.play()
