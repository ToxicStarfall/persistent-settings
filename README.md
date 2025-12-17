<h1>
	Persistent Settings
</h1>
<img width="320" height="224" alt="persistant_settings" src="https://github.com/user-attachments/assets/4e06c7b0-82f5-4201-a444-2c4898707740" />
<p>
	Persistent Settings is a addon for Godot which lets you quickly save and import your favorited nodes, node properties, files, or project settings between different projects.
	<br><br>
	Save your favorite settings and create presets to help speed up the setup phase of new projects.
</p>


<p>
	<a href="https://github.com/ToxicStarfall/persistant-settings/releases">Releases</a> -
	<a href="https://godotengine.org/asset-library/asset/4512">Asset Library</a>
</p>


<br>
<h2>Features</h2>
<h4>Saving and Importing</h4>

- Save your favorite nodes, files, and node properties.
- Save your project's settings configuration.
<img width="162" height="332" alt="persistant_settings_favorite_nodes" src="https://github.com/user-attachments/assets/782b7cdd-2c0e-4746-8801-b015b616201d" />
<img width="341" height="215" alt="persistant_settings_favorite_node_properties" src="https://github.com/user-attachments/assets/4f90ceba-9e74-4a46-af0e-f73b678788da" />


_Note: This addon saves its data in Godot's config folder (...AppData/Roaming/Godot/persistant_settings_plugin)_

<h4>Presets</h4>

- Create presets for different project types.
- Save different configurations for each preset.
<img width="550" height="258" alt="persistant_settings_presets_example" src="https://github.com/user-attachments/assets/2ecc8b11-3479-4004-8623-87c646bcd8db" />

<br>
<h2>Usage</h2>
<h4>Quick Start Tab</h4>

- Import and Save options
	- Import options will retrive the saved settings from the plugin's configuration folder (see "General Settings").
	- Save options will retrive the saved settings from the project's configuration folder (project/.godot/editor).
	- Press the download icon to the right of import/save toggles to import or save only that setting.
	- Toggle the different options to include or exclude that setting from being saved.

- Preset Options
	- Select a preset from the dropdown to delete, import, or save the preset.
	- Specify a new preset name to create a new one, or save an existing one (ignores preset dropdown).
	- Select the import or save buttons to save or import from the selected preset.
	- Note: Selected save/import options above will apply when saving or importing presets.
- Press the "Apply" button to save changes to save/import options.

<h4>Basic Settings Tab</h4>

- General Settings
	- Configure settings related to this plugin.
	- "View Folder" - open the data folder for this plugin.
	- "Show on launch" - toggle to open the persistent settings configuration popup automatically on project launch.
- Project Settings
	- Configure settings related to the project settings file
	- "Include project metadata" - toggle to include per project specific data, such as the project's name, run configurations, enabled plugins, and autoloads when importing and saving.
- Press the "Apply" button to save changes.

<h4>File Viewer</h4>

- Preset Selector - (Optional) Select a preset to view or open. Defaults to the plugin's config folder.
- File Selector - (Optional) Select a file type to view or open. Defaults to all files in the preset.
- View - Generate a preview of the selected preset/file's content. 
- Show Folder - Opens the folder of the selected preset. If a file is selected, then open it using the file type's specified program.


<br>
<h2>Installation</h2>

1. Install using Godot's built-in Asset Library.
2. Download a release, unzip, and place the folder into your project's addons folder.
