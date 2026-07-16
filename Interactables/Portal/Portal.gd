extends StaticBody2D

@export_file("*.tscn") var LevelPath: String
@export var LevelNum: int
@onready var TeleportZone: Area2D = $TeleportZone

func _ready() -> void:
	TeleportZone.body_entered.connect(Entered)

func Entered(Body: Node2D) -> void:
	if Body is CharacterBody2D:
		var file: FileAccess = FileAccess.open(Globals.ConfigPath, FileAccess.READ_WRITE)
		var json = JSON.new()
		var _res = json.parse(file.get_as_text())
		var data = json.get_data()
		data["UnlockedLevel"] = LevelNum
		file.seek(0)
		file.store_string(JSON.stringify(data))
		var pos = file.get_position()
		file.resize(pos)
		file.close()
		
		get_tree().change_scene_to_file(LevelPath)
