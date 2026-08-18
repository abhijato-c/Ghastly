extends Node2D

@export var Target: Node2D
@onready var Sprite = $Sprite
@onready var DetectionZone = $DetectionZone
@onready var ColliderOff = $ColliderOff
@onready var ColliderOn = $ColliderOn

var OnPlate: Array[Node2D] = []
var Pressed: bool = false
var PressedAudio: AudioStream = preload("res://Audio/Effects/PressurePlateOn.mp3")
var ReleasedAudio: AudioStream = preload("res://Audio/Effects/PressurePlateOff.mp3")

func _ready() -> void:
	DetectionZone.body_entered.connect(ObjectEntered)
	DetectionZone.area_entered.connect(ObjectEntered)
	DetectionZone.body_exited.connect(ObjectExited)
	DetectionZone.area_exited.connect(ObjectExited)
	
	Sprite.play("Off")
	ColliderOn.disabled = true
	ColliderOff.disabled = false

func ObjectEntered(Body: Node2D) -> void:
	if not Body in OnPlate:
		OnPlate.append(Body)
	if not Pressed:
		Activate()

func ObjectExited(Body: Node2D) -> void:
	if Body in OnPlate:
		OnPlate.erase(Body)
	if OnPlate.is_empty() and Pressed:
		Deactivate()

func Activate() -> void:
	Pressed = true
	Sprite.play("On")
	ColliderOn.set_deferred("disabled", false)
	ColliderOff.set_deferred("disabled", true)
	Target.Activate()
	BGM.PlayEffect(PressedAudio)

func Deactivate() -> void:
	Pressed = false
	Sprite.play("Off")
	ColliderOn.set_deferred("disabled", true)
	ColliderOff.set_deferred("disabled", false)
	Target.Deactivate()
	BGM.PlayEffect(ReleasedAudio)

func Reset() -> void:
	Deactivate()
