extends Node2D

@export var Target: Node2D
@onready var Sprite = $Sprite

var Active: bool = false

func _ready() -> void:
	Sprite.play("Off")

func Activate():
	Active = true
	Sprite.play("On")
	Target.Activate()

func Deactivate():
	Active = false
	Sprite.play("Off")
	Target.Deactivate()

func Interact():
	if Active:
		Deactivate()
	else:
		Activate()

func Reset():
	Deactivate()
