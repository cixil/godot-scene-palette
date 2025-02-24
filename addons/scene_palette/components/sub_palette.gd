@tool
extends Control
class_name PalettePluginSubPalette

signal minimize_changed(value: bool)

@export var arrow_closed:Texture2D
@export var arrow_open:Texture2D

@onready var scene_drop_grid_container = %SceneDropGridContainer
@onready var title_minimize_button = %TitleMinimizeButton
@onready var sub_palette_container = %SubPaletteContainer
@onready var content_container = %ContentContainer
@onready var panel = %Panel

## multiply the title color by this much for the background panel
const PANEL_COLOR_AMT = 0.8
var directory:String

# only set to false by the top level palette
var expandable:bool = true:
	set(value):
		expandable = value
		if not expandable:
			title_minimize_button.icon = null
			title_minimize_button.disabled = true

var minimized:bool = false:
	set(value):
		minimized = value
		
		if minimized:
			title_minimize_button.icon = arrow_closed
			content_container.hide()
		else:
			title_minimize_button.icon = arrow_open
			content_container.show()

		title_minimize_button.set_pressed_no_signal(minimized)
		minimize_changed.emit(minimized)

func set_title(title:String):
	title_minimize_button.text = title.replace('-', ' ').replace('_', ' ')

func add_item(item:PalettePluginSceneDrop):
	scene_drop_grid_container.add_child(item)

func instantiate_previews(value:bool):
	for node in scene_drop_grid_container.get_children():
		if node is PalettePluginSceneDrop:
			node.instantiate_scene_preview = value
	for node in sub_palette_container.get_children():
		if node is PalettePluginSubPalette:
			node.instantiate_previews(value)

# only used by top level palette
#func clear_items():
	#for node in scene_drop_grid_container.get_children():
		#node.queue_free()
	#for node in sub_palette_container.get_children():
		#node.queue_free()

# only used by top level palette
func set_color(color:Color):
	var stylebox:StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = color
	stylebox.set_content_margin_all(7)
	title_minimize_button.add_theme_stylebox_override('normal', stylebox)
	title_minimize_button.add_theme_stylebox_override('disabled', stylebox)

	var panel_stylebox:StyleBoxFlat = panel.get_theme_stylebox('panel')
	var new_stylebox = panel_stylebox.duplicate()
	new_stylebox.bg_color = _get_multiplied_color(color, PANEL_COLOR_AMT)
	panel.add_theme_stylebox_override('panel', new_stylebox)

func _get_multiplied_color(color:Color, amt:float) -> Color:
	return Color(color.r * amt, color.g * amt, color.b * amt)

func add_subpalette(palette:PalettePluginSubPalette):
	sub_palette_container.add_child(palette)

func _on_title_minimize_button_toggled(toggled_on):
	if expandable:
		self.minimized = toggled_on		

func _on_showin_file_system_button_pressed():
	EditorInterface.get_file_system_dock().navigate_to_path(directory)
