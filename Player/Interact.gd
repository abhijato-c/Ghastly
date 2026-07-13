extends Area2D
@export var InteractLabel: Label

const InteractActions: Array[String] = ["Interact1", "Interact2", "Interact3", "Interact4"]
const KeyLabels: Array[String] = ['E', 'F', 'G', 'H']
var Interactables: Array[Area2D] = []

func _ready() -> void:
	area_entered.connect(AreaEntered)
	area_exited.connect(AreaExited)

func _unhandled_input(event: InputEvent) -> void:
	for i in range(Interactables.size()):
		if event.is_action_pressed(InteractActions[i]):
			Interactables[i].Interact()
			owner.InteractionHappened(Interactables[i].Interact as Callable)
			break

func AreaEntered(Area: Area2D) -> void:
	if Area not in Interactables:
		Interactables.append(Area)
		UpdateLabel()

func AreaExited(Area: Area2D) -> void:
	if Area in Interactables:
		Interactables.erase(Area)
		UpdateLabel()

func UpdateLabel() -> void:
	var Text: String = ""
	for i in range(Interactables.size()):
		Text += "Press {a} to interact with {b}\n".format({'a': KeyLabels[i], 'b': Interactables[i].name})
	if Text == "":
		Text = "No interactables in range"
	else:
		Text = Text.left(-1)
	InteractLabel.text = Text
