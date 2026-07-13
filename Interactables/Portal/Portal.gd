extends Area2D

@export var Level: int

func _ready() -> void:
	body_entered.connect(Entered)

func Entered(Body: Node2D) -> void:
	if Body is CharacterBody2D:
		get_tree().change_scene_to_file("res://Levels/Level-{Level}/Level-{Level}.tscn".format({"Level": Level}))
