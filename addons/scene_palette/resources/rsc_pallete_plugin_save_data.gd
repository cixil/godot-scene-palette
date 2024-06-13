@tool
extends Resource
class_name PalettePluginSaveData
var _default_button_color = '#21262e'

# can't use this because Godot doesn't support saving nested custom resources yet
#@export var favorites:Array[PalettePluginFavorite] = []
@export var favorites:Dictionary

func add_favorite(directory, instantiate_scenes, color=_default_button_color):
	favorites[directory] = {
		instantiate_scenes_for_previews = instantiate_scenes,
		color = color
	}
