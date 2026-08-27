@tool
extends Control

const pp = 'ScenePalettePlugin: '  # prepended to printed messages
const MOUSE_HOVER_SCALE_ADJUST = 0.05

@onready var picture_point = %PicturePoint
@onready var name_label = %NameLabel
@onready var texture_rect: TextureRect = %TextureRect
@onready var right_click_menu: PopupMenu = %RightClickMenu


var _scene_path:String

var _mode:PalettePluginSceneDrop.display_modes
func set_display_mode(mode:PalettePluginSceneDrop.display_modes):
	_mode = mode
	match mode:
		PalettePluginSceneDrop.display_modes.EDITOR_THUMBNAIL:
			pass
		PalettePluginSceneDrop.display_modes.IMAGE_FILE:
			pass
		PalettePluginSceneDrop.display_modes.INSTANTIATE_SCENE:
			if _scene_path:
				set_scene(_scene_path)

var png_directory:String = ''

func adjust_scale(amt:float):
	picture_point.scale = Vector2(amt, amt)

func show_file_label(show:bool):
	# setting text here instead of in set_scene seems to work better
	name_label.text = _create_display_label(_scene_path)
	name_label.visible = show

## Converts a filepath to just the filename without the directory or file extension
## If it's not a tscn or scn file, the file extension is left on
func _create_display_label(path:String) -> String:
	var display_label = path.split('/')[-1]
	display_label = display_label.trim_suffix('.tscn')
	display_label = display_label.trim_suffix('.scn')
	
	display_label = display_label.replace('_', ' ').replace('-', ' ')
	return display_label

func set_scene(path:String):
	tooltip_text = path
	_scene_path = path
	var file_extension = path.split('.')[-1]
	
	for node in picture_point.get_children():
		node.queue_free()
	
	match file_extension:
		'png':
			texture_rect.texture = load(_scene_path)
		'tscn', 'scn':
			match _mode:
				PalettePluginSceneDrop.display_modes.EDITOR_THUMBNAIL:
					_make_preview()
				PalettePluginSceneDrop.display_modes.IMAGE_FILE:
					var file_name:String = path.substr(0, len(path) - len(file_extension))
					file_name = file_name.split('/')[-1]
					file_name = file_name.to_lower()
					var potential_image_files = []
					potential_image_files.append(file_name + 'png')
					potential_image_files.append((file_name.replace('_', '-') + 'png'))
					var texture_file = _find_png_preview_file(png_directory, potential_image_files)
					if texture_file.is_empty():
						_mode = PalettePluginSceneDrop.display_modes.EDITOR_THUMBNAIL
						_make_preview()
					else:
						texture_rect.texture = load(texture_file) as Texture2D
				PalettePluginSceneDrop.display_modes.INSTANTIATE_SCENE:
					var node:Node = load(_scene_path).instantiate()
					if _scene_is_safe(node):
						picture_point.add_child(node)
						return
					# if scene is not safe to instantiate, just keep a preview
					_make_preview()
		'obj':
			_make_preview()

func _find_png_preview_file(directory, potential_image_files) -> String:
	for png_file in potential_image_files:
		var full_path = directory + '/' + png_file
		if FileAccess.file_exists(full_path):
			return full_path
		
	for subdir in DirAccess.get_directories_at(directory):
		var path = _find_png_preview_file(directory + '/' + subdir, potential_image_files)
		if not path.is_empty():
			return path
	return ''
	#_make_preview() # default to editor preview



func _make_preview():
	var resource_previewer = EditorInterface.get_resource_previewer()
	resource_previewer.queue_resource_preview(_scene_path, self, '_on_resource_preview', null)

func _on_resource_preview(path:String, preview:Texture2D, thumbnail_preview:Texture2D, _user_data):
	var texture_rect = TextureRect.new()
	add_child(texture_rect)
	texture_rect.texture = preview
	hide()
	show()

## determine if scene is safe to instantiate as a preview
func _scene_is_safe(scene:Node) -> bool:
	# if scene is a Node then it can't be positioned within the panel and
	# clip_contents does not work.
	if not scene is Node2D:
		print("%Not instantiating preview for %s because it is not a Node2D" %
			[pp, scene.scene_file_path]
			)
		return false
	# if scene contains a camera, the entire editor is repositioned
	if _scene_contains_camera(scene):
		print("%Not instantiating preview for %s because it contains a camera." %
			[pp, scene.scene_file_path]
			)
		return false
	return true

func _scene_contains_camera(scene:Node) -> bool:
	if scene is Camera2D:
		return true
	for node in scene.get_children():
		var result:bool = _scene_contains_camera(node)
		if result:
			return result
	return false

## Mimics the data that would be provided if a file were dragged from the 
## FileSystem browser
func _make_file_data() -> Dictionary:
	return {
		'type': 'files',
		'files': [_scene_path],
		'from': ''
	}

func _make_drag_preview() -> Control:
	var control:Control = Control.new()
	match _mode:
		PalettePluginSceneDrop.display_modes.EDITOR_THUMBNAIL:
			pass
		PalettePluginSceneDrop.display_modes.IMAGE_FILE:
			var tex = TextureRect.new()
			tex.texture = texture_rect.texture
			tex.size = Vector2(32, 32)
			tex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST # optimize for pixel art. The preview is so small that you won't notice for other styles
			return tex
		PalettePluginSceneDrop.display_modes.INSTANTIATE_SCENE:
			var scene = load(_scene_path).instantiate()
			control.add_child(scene)
	# TODO add an alternate image here
	return control

func _get_drag_data(at_position):
	set_drag_preview(_make_drag_preview())
	return _make_file_data()

func _on_mouse_entered():
	scale = Vector2.ONE + Vector2(MOUSE_HOVER_SCALE_ADJUST, MOUSE_HOVER_SCALE_ADJUST)

func _on_mouse_exited():
	scale = Vector2.ONE


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			right_click_menu.position = DisplayServer.mouse_get_position() - Vector2i(5,5)
			right_click_menu.popup()


func _on_right_click_menu_mouse_exited() -> void:
	right_click_menu.hide()
