@tool
extends Control

const pp = 'ScenePalettePlugin: '  # prepended to printed messages
const MOUSE_HOVER_SCALE_ADJUST = 0.05

@onready var picture_point = %PicturePoint
@onready var name_label = %NameLabel
@onready var texture_rect: TextureRect = %TextureRect

var _scene_path:String
var instantiate_scene_preview:
	set(value):
		instantiate_scene_preview = value
		# refresh the preview
		if _scene_path:
			set_scene(_scene_path)

func adjust_scale(amt:float):
	picture_point.scale = Vector2(amt, amt)

func show_file_label(show:bool):
	# setting text here instead of in set_scene seems to work better
	name_label.text = _create_display_label(_scene_path)
	name_label.visible = show

func _create_display_label(path:String) -> String:
	var display_label = path.split('.tscn')[0].split('/')[-1]
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
		'tscn':
			if instantiate_scene_preview:
					var node:Node = load(_scene_path).instantiate()
					if _scene_is_safe(node):
						picture_point.add_child(node)
						return
			# if scene is not safe to instantiate, just keep a preview
			_make_preview()
		'obj':
			_make_preview()

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
	if instantiate_scene_preview:
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
