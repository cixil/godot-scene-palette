#  Scene Palette

**A plugin for Godot 4 to easily drag and drop nodes into a scene from a palette.**

![gif of basic usage](/gifs/basic-use.gif)


## Using Scene Palette
The Scene Palette Plugin is essentially an alternative file browser with tiled
thumbnails, making it easier to see all your scenes at once.

Dragging and dropping scenes from the Scene Palette induces the same behavior
as dragging and dropping `tscn` or `scn` files from the file browser, so you can take
advantage of the same keyboard shortcuts, such as holding `ctrl` when dropping
a file to add it as a child of the currently selected node.


#### Navigating to a new Palette
Using the file browser on top, navigate to the folder containing scenes for
your palette. The plugin will create a palette automatically using the scenes
in this folder. Nested folders will also be shown as expandable "sub-palettes". 

Press the heart button next to the file selector to save this directory to your
favorites. Once it is in your favorites, any settings you change will persist when closing and reopening the editor.


#### More Options/Settings
- Change the background color of your favorite palettes to quickly differentiate them.
- You can use different display modes to generate thumbnails:
  - use the editor's built-in previews. If you are using editor previews and no preview shows up, open the scene, center the image and save it again. You may need to re-open the folder in the plugin, but this should update the thumbnail.
  - use png files with the same name as the scene file (can be in a separate folder)
  - for pixel art or small 2D assets, instantiate the actual scenes within the thumbnails.
- Flatten subdirectories so it shows as a single palette
- Enable "non scene files" to directly drag other files such as `png`, `obj`, etc onto the workspace.


## Installation
1. Download [Scene Palette from Asset Store in the Godot editor](https://store.godotengine.org/asset/cecilia/scene-palette/) (or the older [Assetlib](https://godotengine.org/asset-library/asset/3074)) or simply copy the contents of the `addons` folder of this repository into the `addons` folder in your project.
2. Enable the plugin in your project settings.
#### Upgrading
1. Disable the plugin in your project settings
2. (optional) If you want to save all of your favorited directories and colors, copy `addons/scene_palette/save_data/save_data.tres` to another location in your file system
3. Delete `addons/scene_palette`
4. Reinstall the plugin
5. (optional) Copy the save data file back into the `addons/scene_palette/save_data/` directory.
6. Enable the plugin in your project settings.


## Issues and Feature Requests
Feel free to submit an issue or PR for small feature requests.

## Like this Plugin?
<!-- <a href='https://ko-fi.com/cixil'> <img height=32 src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' /></a> -->

You may like my other plugin, [Snap Rotate](https://github.com/cixil/snap-rotate-godot-plugin/tree/main)

#### Similar Plugins not by me:
- [Kobewi's Godot Instance dock](https://github.com/KoBeWi/Godot-Instance-Dock)
  is very similar and has a couple more advanced features, but you create docks by adding scenes to them manually, where as this plugin uses an existing directory structure and has subfolders. Worth checking out to see which better fits your needs.
- [https://github.com/MightyPrinny/godot-scene-palette/tree/master](https://github.com/MightyPrinny/godot-scene-palette/tree/master) (Godot 3)


