extends CharacterBody2D

@export var Friction: float
@onready var Sprite: AnimatedSprite2D = $Sprite
signal Died(PositionHistory: Array, InteractHistory: Array)

@export_group("RedPhysics")
@export var RedSpeed: float
@export var RedJumpForce: float
@export var RedGravity: float

@export_group("YellowPhysics")
@export var YellowSpeed: float
@export var YellowJumpForce: float
@export var YellowGravity: float

@export_group("RegularPhysics")
@export var RegularSpeed: float
@export var RegularJumpForce: float
@export var RegularGravity: float

var Speed: float
var JumpForce: float
var Gravity: float

var Direction: int = 0
var FrameNum: int = 0
var TimeElapsed: float = 0.0
var TimeAccumulator: float = 0.0
static var Interaction: Callable = Callable()
var InteractHistory: Array[Callable] = []
var PositionHistory: Array[Vector2] = []

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += Gravity * delta
	elif Input.is_action_pressed("Jump"):
		velocity.y = -JumpForce
	
	Direction = 0
	if Input.is_action_pressed("MoveLeft"):
		Direction -= 1
	if Input.is_action_pressed("MoveRight"):
		Direction += 1
	
	velocity.x = Speed * Direction
	Sprite.flip_h = (Direction == -1)
	if velocity.x > 0:
		velocity.x = max(0, velocity.x - Friction)
	elif velocity.x < 0:
		velocity.x = min(0, velocity.x + Friction)
	
	move_and_slide()
	
	if velocity.x != 0:
		Sprite.play("Move")
	else:
		Sprite.play("Idle")
	
	TimeElapsed += delta
	TimeAccumulator += delta
	
	while TimeAccumulator >= Globals.FrameTime:
		UpdateHistory()
		TimeAccumulator -= Globals.FrameTime
	
	if TimeElapsed >= Globals.TimeLimit:
		Die()

func UpdateHistory() -> void:
	PositionHistory.append(global_position)
	InteractHistory.append(Interaction)
	Interaction = Callable()

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
	
	if Col == Globals.PlayerColor.Red:
		Speed = RedSpeed
		JumpForce = RedJumpForce
		Gravity = RedGravity
	elif Col == Globals.PlayerColor.Yellow:
		Speed = YellowSpeed
		JumpForce = YellowJumpForce
		Gravity = YellowGravity
	else:
		Speed = RegularSpeed
		JumpForce = RegularJumpForce
		Gravity = RegularGravity
	
	set_physics_process(true)
