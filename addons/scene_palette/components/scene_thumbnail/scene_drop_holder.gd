@tool
extends MarginContainer
class_name PalettePluginSceneDrop
@onready var scene_drop = %SceneDrop
@onready var name_label = %NameLabel

# Note most of the code is in scene_drop.gd attached to SceneDrop, this is a wrapper.
# A wrapper is used because it made implementing the drag and drop code easier

enum display_modes {EDITOR_THUMBNAIL=0,  IMAGE_FILE=1, INSTANTIATE_SCENE=2}

func set_png_directory(dir:String) -> void:
	scene_drop.png_directory = dir

func set_display_mode(mode:display_modes):
	scene_drop.set_display_mode(mode)

var _scene_path:String

func set_scene(path:String):
	_scene_path = path
	scene_drop.set_scene(path)
	var scene_name = _scene_path.split('.')[0].split('/')[-1]
	name_label.text = scene_name
	name_label.tooltip_text = scene_name

func _on_open_scene_button_pressed():
	EditorInterface.open_scene_from_path(_scene_path)

func adjust_scale(amt:float):
	scene_drop.adjust_scale(amt)

func show_file_label(show:bool):
	scene_drop.show_file_label(show)

func _on_right_click_menu_index_pressed(index: int) -> void:
	match index:
		0:
			EditorInterface.open_scene_from_path(_scene_path)
		1:
			EditorInterface.get_file_system_dock().navigate_to_path(_scene_path)
