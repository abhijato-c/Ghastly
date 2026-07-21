extends StaticBody2D

@export_file("*.tscn") var LevelPath: String
@export var LevelNum: int
@onready var TeleportZone: Area2D = $TeleportZone

func _ready() -> void:
	TeleportZone.body_entered.connect(Entered)

func Entered(Body: Node2D) -> void:
	if Body is CharacterBody2D:
		Globals.Config["Unlocked Level"] = LevelNum
		Globals.SaveConfig()
		get_tree().change_scene_to_file(LevelPath)
