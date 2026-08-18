extends Node2D

@export var Target: Node2D
@onready var Sprite = $Sprite

var Active: bool = false
var Audio: AudioStream = preload("res://Audio/Effects/Lever.mp3")

func _ready() -> void:
	Sprite.play("Off")

func Activate():
	Active = true
	Sprite.play("On")
	Target.Activate()
	BGM.PlayEffect(Audio)

func Deactivate():
	Active = false
	Sprite.play("Off")
	Target.Deactivate()
	BGM.PlayEffect(Audio)

func Interact():
	if Active:
		Deactivate()
	else:
		Activate()

func Reset():
	Deactivate()
