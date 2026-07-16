extends Node2D

@onready var Sprite = $Sprite

var PositionHistory: Array[Vector2] = []
var InteractionHistory: Array[Callable] = []
var CurrentFrame: int = 0
var Accumulator: float = 0

func _ready() -> void:
	Disable()

func Disable() -> void:
	set_physics_process(false)
	set_deferred("monitorable", false)
	hide()

func Enable() -> void:
	CurrentFrame = 0
	Accumulator = 0
	set_deferred("monitorable", true)
	set_physics_process(true)
	show()

func UpdateHistory(PosHistory: Array[Vector2], InteractHistory: Array[Callable]) -> void:
	PositionHistory = PosHistory
	InteractionHistory = InteractHistory

func Reset() -> void:
	set_physics_process(false)
	CurrentFrame = 0
	Accumulator = 0
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	Accumulator += delta
	while Accumulator > Globals.FrameTime:
		if CurrentFrame >= PositionHistory.size():
			Disable()
			break
		global_position = PositionHistory[CurrentFrame]
		if InteractionHistory[CurrentFrame]:
			InteractionHistory[CurrentFrame].call()
		Accumulator -= Globals.FrameTime
		CurrentFrame += 1
