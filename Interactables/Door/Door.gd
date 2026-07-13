extends Node2D

@onready var Sprite = $Sprite
@onready var Collider = $Collider
var Open: bool = false

func _ready() -> void:
	Deactivate()

func Activate() -> void:
	Sprite.play("Open")
	Collider.set_deferred("disabled", true)

func Deactivate() -> void:
	Sprite.play("Closed")
	Collider.set_deferred("disabled", false)

func Reset() -> void:
	Deactivate()
