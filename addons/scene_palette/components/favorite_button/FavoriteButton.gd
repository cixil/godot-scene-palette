@tool
extends HBoxContainer
class_name PalettePluginFavoriteButton
@onready var button = %Button
@onready var delete_button = %DeleteButton
@onready var color_picker_button = %ColorPickerButton

var directory:String:
	set(value):
		directory = value
		var dir_name = directory.split('/')[-1]
		button.text = dir_name

signal favorite_selected(dir)
signal favorite_color_changed(dir, color)
signal favorite_removed(dir)

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
	#button.add
	button.add_theme_stylebox_override('hover', stylebox)
