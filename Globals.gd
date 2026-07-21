extends Node

const FrameRate: int = 30
const TimeLimit: int = 15
const NumFrames: int = FrameRate * TimeLimit
const FrameTime: float = 1.0 / FrameRate

const ConfigPath: String = "user://Save.json"
const DefaultConfig: Dictionary = {
	"Unlocked Level": 0,
	"Master Volume": 5,
	"Background Music": 5,
	"Sound Effects": 5,
	"Show Ghosts": true,
	"Portal Animation": true
}
var Config = DefaultConfig.duplicate()

enum PlayerColor {
	Red,
	Yellow,
	Green,
	Blue
}

const VisualColor: Dictionary = {
	PlayerColor.Red:    Color(1.0, 0.25, 0.25),
	PlayerColor.Yellow: Color(1.0, 0.85, 0.1), 
	PlayerColor.Green:  Color(0.2, 0.9, 0.45),
	PlayerColor.Blue:   Color(0.1, 0.65, 1.0)
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func LoadConfig() -> void:
	if not FileAccess.file_exists(ConfigPath):
		SaveConfig()
	else:
		var file: FileAccess = FileAccess.open(ConfigPath, FileAccess.READ)
		var json = JSON.new()
		var _res = json.parse(file.get_as_text())
		Config = json.get_data() as Dictionary

func SaveConfig() -> void:
	var file: FileAccess = FileAccess.open(ConfigPath, FileAccess.WRITE)
	file.store_string(JSON.stringify(Config, "\t"))
	file.close()

func ResetConfig() -> void:
	Config = DefaultConfig.duplicate()
	SaveConfig()
