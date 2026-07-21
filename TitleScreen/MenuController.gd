extends Node

@export_group("Menu Tweaks")
@export var MenuOptions: VBoxContainer;
@export var BaseFont: Font
@export var SelectedColor: Color = Color8(230, 200, 70, 255)
@export var DefaultColor: Color = Color8(220, 220, 220, 255)
@export var SelectedFontSize: int = 100
@export var DefaultFontSize: int = 60
@export var SelectedStretch: float = 1.5
@export var DefaultStretch: float = 1.0
@export var SelectedIndent: float = 0.1
@export var SelectedEmbolden: float = 0.5
@export var SelectedSpacing: float = 0
@export var BackgroundExtra: float = 0.5
@export var TweenDuration: float = 1.5

@export_group("Menu Objects")
@export var BackgroundNode: TextureRect
@export var MenuObjects: Array[Panel]
@export var LevelHighlight: TextureRect
@export var LevelGrid: GridContainer
@export var TutorialContainer: Panel
@export var OptionsContainer: Panel
@export var OptionsHighlight: Panel

@export_group("Options")
@export var MasterVolSlider: Slider
@export var BackgroundVolSlider: Slider
@export var SFXSlider: Slider
@export var GhostVisText: Label
@export var PortalAnimText: Label

@export_group("Textures")
@export var LockIcon: Texture2D

var MenuOpened: int = 0
var MenuIndex: int = 0
var LevelIndex: int = 0
var TutorialIndex: int = 0
var OptionsIndex: int = 0


var MenuLabels: Array[Label]
var LevelLabels: Array[Label]
var TutorialSlides: Array[Control]
var OptionsList: Array[Control]

var Offset: float
var BackgroundTween: Tween

func _ready() -> void:
	Globals.LoadConfig()
	
	MenuLabels.assign(MenuOptions.get_children())
	LevelLabels.assign(LevelGrid.get_children())
	TutorialSlides.assign(TutorialContainer.get_children())
	OptionsList.assign(OptionsContainer.get_children())
	
	Offset = (BackgroundExtra / (MenuLabels.size() - 1))
	BackgroundNode.anchor_top = -(BackgroundExtra / 2)
	BackgroundNode.anchor_bottom = 1 + (BackgroundExtra / 2)
	
	for i in range(Globals.Config["Unlocked Level"] + 1, 10):
		var label = LevelLabels[i]
		var Style = label.get_theme_stylebox("normal").duplicate() as StyleBoxTexture
		Style.texture = LockIcon
		label.add_theme_stylebox_override("normal", Style)
	
	UpdateMenuSelection()
	UpdateLevelSelection()
	UpdateTutorialSelection()
	UpdateOptionSelection()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		for panel: Panel in MenuObjects:
			panel.hide()
		MenuOpened = 0
	elif MenuOpened == 0:
		MenuAction(event)
	elif MenuOpened == 1:
		LevelAction(event)
	elif MenuOpened == 2:
		TutorialAction(event)
	elif MenuOpened == 3:
		OptionsAction(event)

func MenuAction(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and MenuIndex > 0:
		MenuIndex -= 1
		UpdateMenuSelection()
	elif event.is_action_pressed("ui_down") and MenuIndex < MenuLabels.size() - 1:
		MenuIndex += 1
		UpdateMenuSelection()
	elif event.is_action_pressed("ui_accept"):
		if MenuIndex == 3:
			get_tree().quit()
			return
		MenuObjects[MenuIndex].show()
		MenuOpened = MenuIndex + 1

func LevelAction(event: InputEvent) -> void:
	var PrevLevel = LevelIndex
	if event.is_action_pressed("ui_up"):
		LevelIndex -= 5
	elif event.is_action_pressed("ui_down"):
		LevelIndex += 5
	elif  event.is_action_pressed("ui_left"):
		LevelIndex -= 1
	elif  event.is_action_pressed("ui_right"):
		LevelIndex += 1
	elif event.is_action_pressed("ui_accept") and LevelIndex <= Globals.Config["Unlocked Level"]:
		get_tree().change_scene_to_file("res://Levels/Level-{n}.tscn".format({"n": LevelIndex + 1}))
		return
	
	if LevelIndex < 0 or LevelIndex > 9 or LevelIndex > Globals.Config["Unlocked Level"]:
		LevelIndex = PrevLevel
	else:
		UpdateLevelSelection()

func TutorialAction(event: InputEvent) -> void:
	if  event.is_action_pressed("ui_left") and TutorialIndex > 0:
		TutorialIndex -= 1
	elif  event.is_action_pressed("ui_right") and TutorialIndex < TutorialSlides.size() - 1:
		TutorialIndex += 1
	UpdateTutorialSelection()

func OptionsAction(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and OptionsIndex > 0:
		OptionsIndex -=1
		UpdateOptionSelection()
	elif event.is_action_pressed("ui_down") and OptionsIndex < OptionsList.size() - 1:
		OptionsIndex += 1
		UpdateOptionSelection()
	elif event.is_action_pressed("ui_right"):
		if OptionsIndex == 0 and Globals.Config["Master Volume"] < 10:
			Globals.Config["Master Volume"] += 1
		elif  OptionsIndex == 1 and Globals.Config["Background Music"] < 10:
			Globals.Config["Background Music"] += 1
		elif  OptionsIndex == 2 and Globals.Config["Sound Effects"] < 10:
			Globals.Config["Sound Effects"] += 1
		elif OptionsIndex == 3:
			Globals.Config["Show Ghosts"] = not Globals.Config["Show Ghosts"]
		elif OptionsIndex == 4:
			Globals.Config["Portal Animation"] = not Globals.Config["Portal Animation"]
		UpdateOptionSelection()
		Globals.SaveConfig()
	elif event.is_action_pressed("ui_left"):
		if OptionsIndex == 0 and Globals.Config["Master Volume"] > 0:
			Globals.Config["Master Volume"] -= 1
		elif  OptionsIndex == 1 and Globals.Config["Background Music"] > 0:
			Globals.Config["Background Music"] -= 1
		elif  OptionsIndex == 2 and Globals.Config["Sound Effects"] > 0:
			Globals.Config["Sound Effects"] -= 1
		elif OptionsIndex == 3:
			Globals.Config["Show Ghosts"] = not Globals.Config["Show Ghosts"]
		elif OptionsIndex == 4:
			Globals.Config["Portal Animation"] = not Globals.Config["Portal Animation"]
		UpdateOptionSelection()
		Globals.SaveConfig()
	elif event.is_action_pressed("ui_accept") and OptionsIndex == 5:
		Globals.ResetConfig()
		UpdateOptionSelection()

func UpdateMenuSelection() -> void:
	for i in range(MenuLabels.size()):
		var option = MenuLabels[i]
		if i == MenuIndex:
			option.add_theme_font_size_override("font_size", SelectedFontSize)
			option.add_theme_color_override("font_color", SelectedColor)
			option.size_flags_stretch_ratio = SelectedStretch;
			
			var Width = MenuOptions.size.x
			var Style = StyleBoxEmpty.new()
			Style.content_margin_left = Width * SelectedIndent
			option.add_theme_stylebox_override("normal", Style)
			
			var Variation = FontVariation.new()
			Variation.base_font = BaseFont
			Variation.variation_embolden = SelectedEmbolden
			Variation.spacing_glyph = SelectedSpacing
			option.add_theme_font_override("font", Variation)
		else:
			option.add_theme_font_size_override("font_size", DefaultFontSize)
			option.add_theme_color_override("font_color", DefaultColor)
			option.size_flags_stretch_ratio = DefaultStretch;
			option.add_theme_font_override("font", BaseFont)
			
			var Style = StyleBoxEmpty.new()
			Style.content_margin_left = 0
			option.add_theme_stylebox_override("normal", Style)
	
	if BackgroundTween and BackgroundTween.is_valid():
		BackgroundTween.kill()
	
	BackgroundTween = create_tween()
	BackgroundTween.set_ease(Tween.EASE_OUT)
	BackgroundTween.set_trans(Tween.TRANS_EXPO)
	
	BackgroundTween.parallel().tween_property(BackgroundNode, "anchor_left", -(Offset * MenuIndex), TweenDuration)
	BackgroundTween.parallel().tween_property(BackgroundNode, "anchor_right", 1 + (Offset * (MenuLabels.size() - 1 - MenuIndex)), TweenDuration)

func UpdateLevelSelection() -> void:
	var LevelLabel = LevelLabels[LevelIndex]
	var offset = (LevelLabel.size - LevelHighlight.size) / 2
	LevelHighlight.global_position = LevelLabel.global_position + offset

func UpdateTutorialSelection() -> void:
	for i in range(TutorialSlides.size()):
		if i == TutorialIndex:
			TutorialSlides[i].show()
		else:
			TutorialSlides[i].hide()

func UpdateOptionSelection() -> void:
	OptionsHighlight.global_position = OptionsList[OptionsIndex].global_position
	OptionsHighlight.size = OptionsList[OptionsIndex].size
	MasterVolSlider.value = Globals.Config["Master Volume"]
	BackgroundVolSlider.value = Globals.Config["Background Music"]
	SFXSlider.value = Globals.Config["Sound Effects"]
	if Globals.Config["Show Ghosts"]:
		GhostVisText.text = "SHOW"
	else:
		GhostVisText.text = "HIDE"
	if Globals.Config["Portal Animation"]:
		PortalAnimText.text = "SHOW"
	else:
		PortalAnimText.text = "HIDE"
