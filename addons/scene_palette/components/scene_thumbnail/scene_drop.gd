@tool
extends Control

@onready var picture_point = %PicturePoint
var _scene_path:String
var instantiate_scene_preview:
	set(value):
		instantiate_scene_preview = value
		# refresh the preview
		if _scene_path:
			set_scene(_scene_path)

func set_scene(path:String):
	tooltip_text = path
	_scene_path = path
	
	for node in picture_point.get_children():
		node.queue_free()
	if instantiate_scene_preview:
		var node:Node = load(_scene_path).instantiate()
		if _scene_is_safe(node):
			picture_point.add_child(node)
			return
		# if scene is not safe to instantiate, just keep a preview
	
	var resource_previewer = EditorInterface.get_resource_previewer()
	resource_previewer.queue_resource_preview(path, self, '_on_resource_preview', null)

# TODO add default texture with a tooltip explaining how to create the thumbnail
# is there a way to create a thumbnail automatically?
func _on_resource_preview(path:String, preview:Texture2D, thumbnail_preview:Texture2D, _user_data):
	var texture_rect = TextureRect.new()
	picture_point.add_child(texture_rect)
	texture_rect.texture = preview
	hide()
	show()

## determine if scene is safe to instantiate as a preview
func _scene_is_safe(scene:Node) -> bool:
	# if scene is a Node then it can't be positioned within the panel and
	# clip_contents does not work.
	if not scene is Node2D:
		return false
	# if scene contains a camera, the entire editor is repositioned
	if _scene_contains_camera(scene):
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
	scale = Vector2(1.05, 1.05)

func _on_mouse_exited():
	scale = Vector2.ONE
