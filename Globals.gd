class_name Globals

const FrameRate: int = 30
const TimeLimit: int = 15
const NumFrames: int = FrameRate * TimeLimit
const FrameTime: float = 1.0 / FrameRate
const ConfigPath: String = "user://Save.json"

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
