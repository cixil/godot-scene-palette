@tool
extends Resource
class_name PalettePluginSaveData
const DEFAULT_BUTTON_COLOR = '#0e1521'

# can't use this because Godot doesn't support saving nested custom resources yet
#@export var favorites:Array[PalettePluginFavorite] = []
@export var favorites:Dictionary

func add_favorite(directory, instantiate_scenes, color=DEFAULT_BUTTON_COLOR):
	favorites[directory] = {
		instantiate_scenes_for_previews = instantiate_scenes,
		color = color,
		scene_preview_scale = 1,
		show_labels = true,
		minimized_dirs = {}
	}
