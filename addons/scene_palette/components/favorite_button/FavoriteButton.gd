@tool
extends HBoxContainer
class_name PalettePluginFavoriteButton
@onready var button:Button = %Button
@onready var delete_button = %DeleteButton
@onready var color_picker_button = %ColorPickerButton
const PALETTE_NAME_MAX_LEN = 17

var directory:String:
	set(value):
		directory = value
		button.text = _create_button_label(directory)

signal favorite_selected(dir)
signal favorite_color_changed(dir, color)
signal favorite_removed(dir)

func _create_button_label(directory) -> String:
	var dir_name:String = directory.split('/')[-1]
	# remove -,_ so that the names look neater
	var btn_name:String = dir_name.replace('-', ' ').replace('_', ' ')
	button.tooltip_text = "Open palette for " + btn_name
	
	# If button names are too long, the behavior of the controls will wrap in
	# a weird way when the panel width is resized in the editor.
	# There's probably a better way to deal with this, but this works for now.
	if len(btn_name) > PALETTE_NAME_MAX_LEN:
		btn_name = btn_name.left(PALETTE_NAME_MAX_LEN)
	return btn_name
	

func _on_favorite_button_pressed():
	favorite_selected.emit(directory)

func _on_delete_button_pressed():
	favorite_removed.emit(directory)
	queue_free()

func set_settings_visibility(is_visible:bool):
	delete_button.visible = is_visible
	color_picker_button.visible = is_visible

func _on_color_picker_button_color_changed(color):
	set_color(color)
	favorite_color_changed.emit(directory, color)
	#delete_button.add_theme_stylebox_override('normal', stylebox)

func set_color(color:Color):
	var stylebox:StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = color
	stylebox.set_content_margin_all(7)
	button.add_theme_stylebox_override('normal', stylebox)
	button.add_theme_stylebox_override('hover', stylebox)
