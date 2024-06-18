#  Scene Palette

**A plugin for Godot 4: Easily drag and drop nodes into a scene from a palette.**

![gif of basic usage](/gifs/basic-use-opt.gif)

Download Scene Palette from AssetLib in the Godot editor or from [https://godotengine.org/asset-library/asset/3074](https://godotengine.org/asset-library/asset/3074)

## Using Scene Palette
The Scene Palette Plugin is essentially an alternative file browser with tiled
thumbnails, making it easier to see all your scenes at once.

Dragging and dropping scenes from the Scene Palette induces the same behavior
as dragging and dropping `.tscn` files from the file browser, so you can take
advantage of the same keyboard shortcuts, such as holding `ctrl` when dropping
a file to add it as a child of the currently selected node.

#### Navigating to a new Palette
Using the file browser on top, navigate to the folder containing scenes for
your palette. The plugin will create a palette automatically using the scenes
in this folder. Nested folders are also allowed. 

Press the heart button next to the file selector to save this directory to your
favorites. You can change the colors of your favorite palettes to diferrentiate
them and saved palettes will persist when closing and reopening the editor.

![gif of basic usage](/gifs/select-fav-opt.gif)


#### More Options
If you are working on a 2D project, you can instantiate the actual scenes to display in the palette thumbnails to get a crisp image, or you can use the editor's built-in previews (default). These previews come from a snapshot of the scene in the editor window from the last time you saved the scene. If you are using editor previews and no preview shows up, open the scene with the the button on the top right of the thumbnail, center the image and save it again. You may need to re-open the folder in the plugin, but this should update the thumbnails.

![gif of basic usage](/gifs/and-more-opt.gif)


## Issues and Feature Requests
Feel free to submit an issue or PR for small feature requests.

#### Similar Plugins
- [https://github.com/KoBeWi/Godot-Instance-Dock](https://github.com/KoBeWi/Godot-Instance-Dock)
- [https://github.com/MightyPrinny/godot-scene-palette/tree/master](https://github.com/MightyPrinny/godot-scene-palette/tree/master) (Godot 3)


