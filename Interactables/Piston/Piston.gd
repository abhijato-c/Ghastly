extends Node2D

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var ColliderOn: CollisionPolygon2D = $ColliderOn
@onready var ColliderOff: CollisionPolygon2D = $ColliderOff
@export var Default: bool = false

func _ready() -> void:
	Deactivate()

func Reset() -> void:
	Deactivate()

func Expand() -> void:
	Sprite.play("On")
	ColliderOff.set_deferred("disabled", true)
	ColliderOn.set_deferred("disabled", false)

func Retract() -> void:
	Sprite.play("Off")
	ColliderOff.set_deferred("disabled", false)
	ColliderOn.set_deferred("disabled", true)

func Activate() -> void:
	if Default:
		Retract()
	else:
		Expand()

func Deactivate() -> void:
	if Default:
		Expand()
	else:
		Retract()
