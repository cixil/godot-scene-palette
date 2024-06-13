@tool
extends Control
class_name PalettePluginSubPalette

@export var arrow_closed:Texture2D
@export var arrow_open:Texture2D

@onready var scene_drop_grid_container = %SceneDropGridContainer
@onready var title_minimize_button = %TitleMinimizeButton
@onready var sub_palette_container = %SubPaletteContainer
@onready var content_container = %ContentContainer
@onready var panel = %Panel

# only set to false by the top level palette
var expandable:bool = true:
	set(value):
		expandable = value
		if not expandable:
			title_minimize_button.icon = null
			title_minimize_button.disabled = true

func set_title(title:String):
	title_minimize_button.text = title

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
	var amt
	#amt = 3
	#title_minimize_button.add_theme_color_override(
		#'font_disabled_color',
		#Color(color.r * amt, color.g * amt, color.b * amt)
	#)
	
	 #need to make this local
	var panel_stylebox:StyleBoxFlat = panel.get_theme_stylebox('panel')
	var new_stylebox = panel_stylebox.duplicate()
	amt = 0.3
	new_stylebox.bg_color = Color(color.r * amt, color.g * amt, color.b * amt)
	panel.add_theme_stylebox_override('panel', new_stylebox)

func add_subpalette(palette:PalettePluginSubPalette):
	sub_palette_container.add_child(palette)

func _on_title_minimize_button_toggled(toggled_on):
	if expandable:
		if toggled_on:
			title_minimize_button.icon = arrow_closed
			content_container.hide()
		else:
			title_minimize_button.icon = arrow_open
			content_container.show()
