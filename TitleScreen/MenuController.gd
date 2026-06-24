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


var SelIndex: int = 0
var OptionLabels: Array[Node] = []

func _ready() -> void:
	OptionLabels = MenuOptions.get_children()
	UpdateSelection()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and SelIndex > 0:
		SelIndex -= 1
		UpdateSelection()
	elif event.is_action_pressed("ui_down") and SelIndex < OptionLabels.size() - 1:
		SelIndex += 1
		UpdateSelection()
	elif event.is_action_pressed("ui_accept"):
		TriggerSelection()

func UpdateSelection() -> void:
	for i in range(OptionLabels.size()):
		var label = OptionLabels[i] as Label
		if i == SelIndex:
			SelectOption(label);
		else:
			DeselectOption(label);

func TriggerSelection() -> void:
	print(SelIndex)

func SelectOption(option: Label) -> void:
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

func DeselectOption(option: Label) -> void:
	option.add_theme_font_size_override("font_size", DefaultFontSize)
	option.add_theme_color_override("font_color", DefaultColor)
	option.size_flags_stretch_ratio = DefaultStretch;
	option.add_theme_font_override("font", BaseFont)
	
	var Style = StyleBoxEmpty.new()
	Style.content_margin_left = 0
	option.add_theme_stylebox_override("normal", Style)
