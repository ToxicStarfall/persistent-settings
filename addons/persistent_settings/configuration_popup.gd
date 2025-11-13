@tool
extends Window


signal file_save_requested
#signal file_overwrite_requested
signal file_import_requested
signal file_view_requested
signal plugin_settings_saved

var viewed_file
var plugin_settings: ConfigFile

var active: bool = false

const FileConstants = {
	"project_settings": "project.godot",
	"favorite_properties": "favorite_properties",
	"favorite_nodes": "favorites.Node",
	"favorite_files": "favorites",
}

#func _init() -> void:
	#pass
#
#func _ready():
	#print("hello")
	#pass


func _enter_tree() -> void:
	# Prevent running script if the scene is being edited
	if !EditorInterface.get_edited_scene_root() == self:
		active = true
		#print("hi")
		#print("config popup tree entered")
		_connect_buttons()
		#close_requested.connect( func(): hide() )
		%TabBar.tab_changed.connect( _on_tab_changed )


func _exit_tree() -> void:
	if active:
		active = false
		_disconnect_buttons()


# Connect option button signals
func _connect_buttons():
	_initialize_welcome_screen()
	_initialize_general_screen()


# Disconnects signals to prevent errors within editor while editing scenes.
func _disconnect_buttons():
	if has_node("%TabBar"):
		%TabBar.tab_changed.disconnect( _on_tab_changed )

	if has_node("%WelcomeScreen"):
		var WelcomeScreen = %WelcomeScreen
		WelcomeScreen.get_node("%ImportAllButton").pressed.disconnect( file_import_requested.emit )
		WelcomeScreen.get_node("%SaveAllButton").pressed.disconnect( file_save_requested.emit )

	#if has_node("%BasicScreen"):
		#var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection
		#var FavoritePropertiesGroup = %BasicScreen/%FavoritePropertiesSection
		#FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton").pressed.disconnect( file_save_requested.emit )
		#var FavoriteNodesGroup = %BasicScreen/%FavoriteNodesSection
		#FavoriteNodesGroup.get_node("HBoxContainer/SaveButton").pressed.disconnect( file_save_requested.emit )
		#var FavoriteFilesGroup = %BasicScreen/%FavoriteFilesSection
		#FavoriteFilesGroup.get_node("HBoxContainer/SaveButton").pressed.disconnect( file_save_requested.emit )


func _initialize_welcome_screen():
	var WelcomeScreen = %WelcomeScreen
	var ImportOptions = WelcomeScreen.get_node("%ImportOptions")
	var SaveOptions = WelcomeScreen.get_node("%SaveOptions")

	WelcomeScreen.get_node("%ImportAllButton").pressed.connect( file_import_requested.emit
		.bind( ["project.godot", "favorite_properties", "favorites.Node", "favorites"] ))
	WelcomeScreen.get_node("%ImportSelectedButton").pressed.connect( func(): #.bind())
			var arr = []
			for import_option in plugin_settings.get_value("General", "import_options", {}).keys():
				if plugin_settings.get_value("General", "import_options", {})[import_option] == true:
					arr.append( FileConstants.get(import_option) )
			file_import_requested.emit(arr) )
	WelcomeScreen.get_node("%SaveAllButton").pressed.connect( file_save_requested.emit
		.bind( ["project.godot", "favorite_properties", "favorites.Node", "favorites"] ))
	WelcomeScreen.get_node("%SaveSelectedButton").pressed.connect( func(): #.bind())
			var arr = []
			for save_option in plugin_settings.get_value("General", "save_options", {}).keys():
				if plugin_settings.get_value("General", "save_options", {})[save_option] == true:
					arr.append( FileConstants.get(save_option) )
			file_save_requested.emit(arr) )
	WelcomeScreen.get_node("%ApplyButton").pressed.connect( plugin_settings_saved.emit
		.bind()) #ImportOptions, SaveOptions ))

	#WelcomeScreen.get_node("%ImportPropertiesButton").pressed.connect( file_import_requested.emit
		#.bind("favorite_properties") )
	#WelcomeScreen.get_node("%SaveOptions/ProjectSettings/Button").pressed.connect( file_save_requested.emit
		#.bind( "project.godot",  ) )
	var import_options: Dictionary = plugin_settings.get_value("General", "import_options", {})
	for i in import_options.keys():
		if ImportOptions.has_node(NodePath(i)):# + "/CheckBox")):
			var group = ImportOptions.get_node(NodePath(i))# + "/CheckBox"))
			group.get_node("CheckBox").pressed.connect( func():
				import_options[group.name] = group.get_node("CheckBox").button_pressed
				plugin_settings.set_value("General", "import_options", import_options))
	var save_options: Dictionary = plugin_settings.get_value("General", "save_options", {})
	for i in save_options.keys():
		if SaveOptions.has_node(NodePath(i)):# + "/CheckBox")):
			var group = SaveOptions.get_node(NodePath(i))# + "/CheckBox"))
			group.get_node("CheckBox").pressed.connect( func():
				save_options[group.name] = group.get_node("CheckBox").button_pressed
				plugin_settings.set_value("General", "save_options", save_options))

	ImportOptions.get_node("project_settings/Button").pressed.connect( file_import_requested.emit.bind("project.godot"))
	ImportOptions.get_node("favorite_properties/Button").pressed.connect( file_import_requested.emit.bind("favorite_properties"))
	ImportOptions.get_node("favorite_nodes/Button").pressed.connect( file_import_requested.emit.bind("favorites.Node"))
	ImportOptions.get_node("favorite_files/Button").pressed.connect( file_import_requested.emit.bind("favorites"))

	SaveOptions.get_node("project_settings/Button").pressed.connect( file_save_requested.emit.bind("project.godot"))
	SaveOptions.get_node("favorite_properties/Button").pressed.connect( file_save_requested.emit.bind("favorite_properties"))
	SaveOptions.get_node("favorite_nodes/Button").pressed.connect( file_save_requested.emit.bind("favorites.Node"))
	SaveOptions.get_node("favorite_files/Button").pressed.connect( file_save_requested.emit.bind("favorites"))

	WelcomeScreen.get_node("%popup_on_launch").pressed.connect( func():
		plugin_settings.set_value("General", "popup_on_launch", WelcomeScreen.get_node("%popup_on_launch").button_pressed )
		plugin_settings_saved.emit() )


func _initialize_general_screen():
	var file_name: String
	var node_path: String

	var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection
	var FavoritePropertiesGroup = %BasicScreen/%FavoritePropertiesSection
	var FavoriteNodesGroup = %BasicScreen/%FavoriteNodesSection
	var FavoriteFilesGroup = %BasicScreen/%FavoriteFilesSection

	#file_name = "project.godot"
	#plugin_settings.set_value("ProjectSettings", "include_metadata", ProjectSettingsGroup.get_node("IncludeMetadataCheckBox").button_pressed )
	#ProjectSettingsGroup.get_node("IncludeMetadataCheckBox").pressed.connect( plugin_settings.set_value
		#.bind("ProjectSettings", "include_metadata", ProjectSettingsGroup.get_node("IncludeMetadataCheckBox").button_pressed))
	ProjectSettingsGroup.get_node("IncludeMetadataCheckBox").pressed.connect( func():
		plugin_settings.set_value("ProjectSettings", "include_metadata", ProjectSettingsGroup.get_node("IncludeMetadataCheckBox").button_pressed))
	#ProjectSettingsGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	#file_name = "favorite_properties"
	#FavoritePropertiesGroup.get_node("HBoxContainer/ViewButton").pressed.connect( file_view_requested.emit.bind( file_name ))
	#FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	#file_name = "favorites.Node"
	#FavoriteNodesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	#file_name = "favorites"
	#FavoriteFilesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))
	%BasicScreen/%ApplyButton.pressed.connect( plugin_settings_saved.emit )


func _on_close_requested() -> void:
	#print("close")
	#hide()
	pass


func apply_plugin_settings(plugin_settings: ConfigFile):
	var WelcomeScreen = %WelcomeScreen
	var ImportOptions = WelcomeScreen.get_node("%ImportOptions")
	var SaveOptions = WelcomeScreen.get_node("%SaveOptions")

	for import_option in plugin_settings.get_value("General", "import_options", {}).keys():
		if ImportOptions.has_node(import_option + "/CheckBox"):
			ImportOptions.get_node(import_option + "/CheckBox").button_pressed = plugin_settings.get_value("General", "import_options", {})[import_option]
	for save_options in plugin_settings.get_value("General", "save_options", {}).keys():
		if SaveOptions.has_node(save_options + "/CheckBox"):
			SaveOptions.get_node(save_options + "/CheckBox").button_pressed = plugin_settings.get_value("General", "save_options", {})[save_options]
	#WelcomeScreen.get_node("%popup_on_launch").buttong-

	var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection
	ProjectSettingsGroup.get_node("IncludeMetadataCheckBox").button_pressed = plugin_settings.get_value("ProjectSettings", "include_metadata", false)
	#ProjectSettingsGroup.get_node("HBoxContainer/SaveButton")

	var FavoritePropertiesGroup = %BasicScreen/%FavoritePropertiesSection
	#FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton")

	var FavoriteNodesGroup = %BasicScreen/%FavoriteNodesSection
	#FavoriteNodesGroup.get_node("HBoxContainer/SaveButton")

	var FavoriteFilesGroup = %BasicScreen/%FavoriteFilesSection
	#FavoriteFilesGroup.get_node("HBoxContainer/SaveButton")



func _on_tab_changed(tab):
	for child in %Screens.get_children():
		if child.get_index() == tab:
			child.show()
		else:
			child.hide()
