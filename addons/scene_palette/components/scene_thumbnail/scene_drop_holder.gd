@tool
extends MarginContainer
class_name PalettePluginSceneDrop
@onready var scene_drop = %SceneDrop
@onready var name_label = %NameLabel
@onready var open_scene_button: Button = $OpenSceneButton

# Note most of the code is in scene_drop.gd attached to SceneDrop, this is a wrapper.
# A wrapper is used because it made implementing the drag and drop code easier


var instantiate_scene_preview:
	set(value):
		scene_drop.instantiate_scene_preview = value

var _scene_path:String

func set_scene(path:String):
	_scene_path = path
	scene_drop.set_scene(path)
	var scene_name = _scene_path.split('.')[0].split('/')[-1]
	name_label.text = scene_name
	name_label.tooltip_text = scene_name
	
	var file_extension = path.split('.')[-1]
	if file_extension != 'tscn':
		open_scene_button.hide()

func _on_open_scene_button_pressed():
	EditorInterface.open_scene_from_path(_scene_path)

func adjust_scale(amt:float):
	scene_drop.adjust_scale(amt)

func show_file_label(show:bool):
	scene_drop.show_file_label(show)
