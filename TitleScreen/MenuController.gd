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

@export_group("Menu Objects")
@export var MenuObjects: Array[Panel]
@export var LevelHighlight: TextureRect
@export var LevelGrid: GridContainer

var MenuOpened: int = 0
var MenuIndex: int = 0
var LevelIndex: int = 0
var MenuLabels: Array[Node] = []
var LevelLabels: Array[Node] = []

func _ready() -> void:
	MenuLabels = MenuOptions.get_children()
	UpdateMenuSelection()
	
	LevelLabels = LevelGrid.get_children()
	UpdateLevelSelection()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		for panel: Panel in MenuObjects:
			panel.hide()
		MenuOpened = 0
	elif MenuOpened == 0:
		MenuAction(event)
	elif MenuOpened == 1:
		LevelAction(event)

func MenuAction(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and MenuIndex > 0:
		MenuIndex -= 1
		UpdateMenuSelection()
	elif event.is_action_pressed("ui_down") and MenuIndex < MenuLabels.size() - 1:
		MenuIndex += 1
		UpdateMenuSelection()
	elif event.is_action_pressed("ui_accept"):
		MenuObjects[MenuIndex].show()
		MenuOpened = MenuIndex + 1

func LevelAction(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and LevelIndex > 4:
		LevelIndex -= 5
	elif event.is_action_pressed("ui_down") and LevelIndex < 5:
		LevelIndex += 5
	elif  event.is_action_pressed("ui_left") and LevelIndex > 0:
		LevelIndex -= 1
	elif  event.is_action_pressed("ui_right") and LevelIndex < 9:
		LevelIndex += 1
	UpdateLevelSelection()

func UpdateMenuSelection() -> void:
	for i in range(MenuLabels.size()):
		var option = MenuLabels[i] as Label
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

func UpdateLevelSelection() -> void:
	var LevelLabel = LevelLabels[LevelIndex] as Control
	var offset = (LevelLabel.size - LevelHighlight.size) / 2
	LevelHighlight.global_position = LevelLabel.global_position + offset
