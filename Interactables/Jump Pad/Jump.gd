extends Node2D

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var DetectionZone: Area2D = $DetectionZone
@export var Force: float = 1300
@export var ActiveTime: float = 0.5
var Active: bool = false

func _ready() -> void:
	Deactivate()
	DetectionZone.body_entered.connect(Activate)

func Reset() -> void:
	Deactivate()

func Activate(Player: CharacterBody2D) -> void:
	if Active:
		return
	Active = true
	Player.velocity.y = -Force
	Sprite.play("On")
	
	await get_tree().create_timer(ActiveTime).timeout
	Deactivate()

func Deactivate() -> void:
	Sprite.play("Off")
	Active = false
