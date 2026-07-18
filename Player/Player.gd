extends CharacterBody2D

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var WallLeft: RayCast2D = $WallLeft
@onready var WallRight: RayCast2D = $WallRight
signal Died(PositionHistory: Array, InteractHistory: Array)

@export_group("GlobalPhysics")
@export var WallSlideSpeed: float = 60
@export var JumpForce: float = 750

@export_group("Timer")
@export var TimeBar: ProgressBar
@export var CurrPlayer: TextureRect
@export var PrevPlayer: TextureRect
@export var NextPlayer: TextureRect
@export var ElapsedLabel: Label
@export var RemainingLabel: Label


@export_group("RedPhysics")
@export var RedSpeed: float = 250
@export var RedGravity: float = 4000

@export_group("YellowPhysics")
@export var YellowSpeed: float = 500
@export var YellowGravity: float = 1500

@export_group("RegularPhysics")
@export var RegularSpeed: float = 380
@export var RegularGravity: float = 2400

var Speed: float
var Gravity: float

var Direction: int = 0
var FrameNum: int = 0
var TimeElapsed: float = 0.0
var TimeAccumulator: float = 0.0
static var Interaction: Callable = Callable()
var InteractHistory: Array[Callable] = []
var PositionHistory: Array[Vector2] = []
var CurrentColor: Globals.PlayerColor = Globals.PlayerColor.Red

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if CurrentColor == Globals.PlayerColor.Green and velocity.y > 0 and (WallLeft.is_colliding() or WallRight.is_colliding()):
			velocity.y = WallSlideSpeed
		else:
			velocity.y += Gravity * delta
	elif Input.is_action_pressed("Jump"):
		velocity.y = -JumpForce
	
	Direction = 0
	if Input.is_action_pressed("MoveLeft"):
		Direction -= 1
	if Input.is_action_pressed("MoveRight"):
		Direction += 1
	
	if Input.is_action_just_pressed("NextPlayer"):
		if PositionHistory.size() == 0:
			PositionHistory.append(global_position)
		if InteractHistory.size() == 0:
			InteractHistory.append(Callable())
		Die()
		return
	
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	
	
	velocity.x = Speed * Direction
	Sprite.flip_h = (Direction == -1)
	
	move_and_slide()
	
	if velocity.x != 0:
		Sprite.play("Move")
	else:
		Sprite.play("Idle")
	
	TimeElapsed += delta
	TimeAccumulator += delta
	
	while TimeAccumulator >= Globals.FrameTime:
		TimeTick()
		TimeAccumulator -= Globals.FrameTime
	
	if TimeElapsed >= Globals.TimeLimit:
		Die()

func TimeTick() -> void:
	PositionHistory.append(global_position)
	InteractHistory.append(Interaction)
	Interaction = Callable()
	
	TimeBar.value = TimeElapsed / Globals.TimeLimit
	ElapsedLabel.text = "%.1f" % TimeElapsed + '/' + str(Globals.TimeLimit) + ' s'
	RemainingLabel.text = 'T-' + "%.1f" % (Globals.TimeLimit - TimeElapsed) + 's'

static func InteractionHappened(InteractFunc: Callable) -> void:
	Interaction = InteractFunc

func Die() -> void:
	set_physics_process(false)
	
	if PositionHistory.size() < Globals.NumFrames:
		for i in range (PositionHistory.size(), Globals.NumFrames):
			PositionHistory.append(PositionHistory[-1])
	elif PositionHistory.size() > Globals.NumFrames:
		PositionHistory.resize(Globals.NumFrames)
	
	if InteractHistory.size() < Globals.NumFrames:
		for i in range(InteractHistory.size(), Globals.NumFrames):
			InteractHistory.append(Callable())
	elif InteractHistory.size() > Globals.NumFrames:
		InteractHistory.resize(Globals.NumFrames)
	
	Died.emit(PositionHistory, InteractHistory)

func Respawn(Col: Globals.PlayerColor) -> void:
	TimeElapsed = 0.0
	TimeAccumulator = 0.0
	PositionHistory = []
	InteractHistory = []
	CurrentColor = Col
	
	if Col == Globals.PlayerColor.Red:
		Speed = RedSpeed
		Gravity = RedGravity
	elif Col == Globals.PlayerColor.Yellow:
		Speed = YellowSpeed
		Gravity = YellowGravity
	else:
		Speed = RegularSpeed
		Gravity = RegularGravity
	
	var PrevCol = (Globals.PlayerColor.values().size() - 1) if Col == 0 else (Col - 1)  as Globals.PlayerColor
	var NextCol = (Col + 1) % Globals.PlayerColor.values().size() as Globals.PlayerColor
	CurrPlayer.modulate = Globals.VisualColor[Col]
	PrevPlayer.modulate = Globals.VisualColor[PrevCol]
	NextPlayer.modulate = Globals.VisualColor[NextCol]
	TimeBar.get_theme_stylebox("fill").bg_color = Globals.VisualColor[Col]
	
	set_physics_process(true)
