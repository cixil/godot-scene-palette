@tool
extends Control
class_name PalettePluginSubPalette

## This class acts as a shell of a palette. Palette items/title/etc and
## settings are set by palette.gd

signal minimize_changed(value:bool)
signal flatten_changed(value:bool)

@export var arrow_closed:Texture2D
@export var arrow_open:Texture2D

@onready var scene_drop_grid_container = %SceneDropGridContainer
@onready var title_minimize_button = %TitleMinimizeButton
@onready var sub_palette_container = %SubPaletteContainer
@onready var content_container = %ContentContainer
@onready var panel = %Panel
@onready var collapse_sub_dir_button: CheckButton = %CollapseSubDirButton

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


########### Flatten SubPalettes ################################################
# One level of subdirectories can be "flattened" (shown as part of the parent)
# with the toggle in a palette's title bar.
# Flattening works recursively, so if a node's child is flattened, then the
# node is flattened, the child's flattened elements will also be flattened into
# the node's.

var _palette_scenes:Dictionary[PalettePluginSubPalette, Array] = {}  # SceneDrops belonging to SubPalettes
var _palette_subs:Dictionary[PalettePluginSubPalette, Array] = {}  # SubPalettes belonging to SubPalettes

func toggle_flatten_setting_visibility(is_visible:bool) -> void:
	collapse_sub_dir_button.visible = is_visible

var subdirs_flattened:bool = false:
	set(value):
		flatten_changed.emit(value)
		collapse_sub_dir_button.button_pressed = value
		if value:
			if !subdirs_flattened:  # don't reflatten if already flattened, it will lose the correct scene-drop to sub-pallete references
				_flatten_subdirs()
		else:
			_unflatten_subdirs()
		subdirs_flattened = value

func _on_collapse_sub_dir_button_toggled(toggled_on: bool) -> void:
	subdirs_flattened = toggled_on

func get_scene_drops() -> Array[PalettePluginSceneDrop]:
	var arr:Array[PalettePluginSceneDrop]
	arr.assign(scene_drop_grid_container.get_children())
	return arr

func get_sub_palettes() -> Array[PalettePluginSubPalette]:
	var arr:Array[PalettePluginSubPalette]
	arr.assign(sub_palette_container.get_children())
	return arr

func _flatten_subdirs() -> void:
	for palette in get_sub_palettes():
		var drops:Array[PalettePluginSceneDrop] = palette.get_scene_drops()
		_palette_scenes[palette] = drops
		for drop in drops:
			drop.reparent(scene_drop_grid_container)
		
		_palette_subs[palette] = palette.get_sub_palettes()
		for sub in _palette_subs[palette]:
			if !palette.subdirs_flattened:
				sub.reparent(sub_palette_container)
		palette.hide()

func _unflatten_subdirs() -> void:
	for palette in get_sub_palettes():
		palette.show()
		
		for drop in _palette_scenes.get(palette, []):
			scene_drop_grid_container.remove_child(drop)
			palette.add_item(drop)
		
		for sub in _palette_subs.get(palette, []):
			if !palette.subdirs_flattened:
				sub_palette_container.remove_child(sub)
				palette.add_subpalette(sub)
