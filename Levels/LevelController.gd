extends Node2D

@export var Player: CharacterBody2D
@export var GhostPrefab: PackedScene
@export var SpawnPos: Vector2 = Vector2(200, 800)

var CurrentColor: Globals.PlayerColor = Globals.PlayerColor.Red
var Ghosts = {}
var GhostsUnlocked: Array[Globals.PlayerColor] = []

func _ready() -> void:
	Player.modulate = Globals.VisualColor[CurrentColor]
	Player.Respawn(CurrentColor)
	Player.Died.connect(PlayerDied)
	for i in range(Globals.PlayerColor.values().size()):
		var Col = i as Globals.PlayerColor
		var Ghost = GhostPrefab.instantiate()
		Ghost.modulate = Globals.VisualColor[Col]
		add_child(Ghost)
		Ghosts[Col] = Ghost

func PlayerDied(PosHistory: Array[Vector2], InteractHistory: Array[Callable]):
	Ghosts[CurrentColor].UpdateHistory(PosHistory, InteractHistory)
	if CurrentColor not in GhostsUnlocked:
		GhostsUnlocked.append(CurrentColor)
	CurrentColor = (CurrentColor + 1) % Globals.PlayerColor.values().size() as Globals.PlayerColor
	
	Player.global_position = SpawnPos
	Player.modulate = Globals.VisualColor[CurrentColor]
	
	get_tree().call_group("Interactables", "Reset")
	
	for i in range(Globals.PlayerColor.values().size()):
		var Col = i as Globals.PlayerColor
		if Col == CurrentColor or Col not in GhostsUnlocked:
			Ghosts[Col].Disable()
		else:
			Ghosts[Col].Enable()
	
	Player.Respawn(CurrentColor)
