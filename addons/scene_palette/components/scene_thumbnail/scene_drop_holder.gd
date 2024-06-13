@tool
extends MarginContainer
class_name PalettePluginSceneDrop
@onready var scene_drop = %SceneDrop
@onready var name_label = %NameLabel

var instantiate_scene_preview:
	set(value):
		scene_drop.instantiate_scene_preview = value

var _scene_path:String

func set_scene(path:String):
	_scene_path = path
	scene_drop.set_scene(path)
	var scene_name = _scene_path.split('.tscn')[0].split('/')[-1]
	name_label.text = scene_name
	name_label.tooltip_text = scene_name

func _on_open_scene_button_pressed():
	EditorInterface.open_scene_from_path(_scene_path)
