@tool
extends Window


signal file_save_requested
#signal file_overwrite_requested
signal file_import_requested
signal file_view_requested

signal plugin_settings_saved

var viewed_file


#func _init() -> void:
	#pass
#
#func _ready():
	#print("hello")
	#pass


func _enter_tree() -> void:
	_connect_buttons()
	#close_requested.connect( func(): hide() )
	%TabBar.tab_changed.connect( _on_tab_changed )


func _exit_tree() -> void:
	_disconnect_buttons()
	#print("exit")


# Connect option button signals
func _connect_buttons():
	var WelcomeScreen = %WelcomeScreen
	var ImportOptions = WelcomeScreen.get_node("%ImportOptions")
	var SaveOptions = WelcomeScreen.get_node("%SaveOptions")

	WelcomeScreen.get_node("%ImportAllButton").pressed.connect( file_import_requested.emit
		.bind( ["project.godot", "favorite_properties", "favorites.Node", "favorites"] ))
	WelcomeScreen.get_node("%SaveAllButton").pressed.connect( file_save_requested.emit
		.bind( ["project.godot", "favorite_properties", "favorites.Node", "favorites"] ))
	WelcomeScreen.get_node("%ApplyButton").pressed.connect( plugin_settings_saved.emit
		.bind( ImportOptions, SaveOptions ))
	#WelcomeScreen.get_node("%ImportPropertiesButton").pressed.connect( file_import_requested.emit
		#.bind("favorite_properties") )

	#WelcomeScreen.get_node("%SaveOptions/ProjectSettings/Button").pressed.connect( file_save_requested.emit
		#.bind( "project.godot",  ) )

	var file_name: String
	var node_path: String

	var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection
	var FavoritePropertiesGroup = %BasicScreen/%FavoritePropertiesSection
	var FavoriteNodesGroup = %BasicScreen/%FavoriteNodesSection
	var FavoriteFilesGroup = %BasicScreen/%FavoriteFilesSection

	file_name = "project.godot"
	#ProjectSettingsGroup.get_node("MetadataCheckBox").pressed.connect()
	ProjectSettingsGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	file_name = "favorite_properties"
	#FavoritePropertiesGroup.get_node("HBoxContainer/ViewButton").pressed.connect( file_view_requested.emit.bind( file_name ))
	FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	file_name = "favorites.Node"
	FavoriteNodesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	file_name = "favorites"
	FavoriteFilesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))


# Disconnects signals to prevent errors within editor while editing scenes.
func _disconnect_buttons():
	if has_node("%TabBar"):
		%TabBar.tab_changed.disconnect( _on_tab_changed )

	if has_node("%WelcomeScreen"):
		var WelcomeScreen = %WelcomeScreen
		WelcomeScreen.get_node("%ImportAllButton").pressed.disconnect( file_import_requested.emit )
		WelcomeScreen.get_node("%SaveAllButton").pressed.disconnect( file_save_requested.emit )

	if has_node("%BasicScreen"):
		var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection

		var FavoritePropertiesGroup = %BasicScreen/%FavoritePropertiesSection
		FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton").pressed.disconnect( file_save_requested.emit )

		var FavoriteNodesGroup = %BasicScreen/%FavoriteNodesSection
		FavoriteNodesGroup.get_node("HBoxContainer/SaveButton").pressed.disconnect( file_save_requested.emit )

		var FavoriteFilesGroup = %BasicScreen/%FavoriteFilesSection
		FavoriteFilesGroup.get_node("HBoxContainer/SaveButton").pressed.disconnect( file_save_requested.emit )
	pass


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
			SaveOptions.get_node(save_options + "/CheckBox").button_pressed = plugin_settings.get_value("General", "import_options", {})[save_options]

	#ImportOptions.get_node("ProjectSettings/CheckBox").button_pressed = plugin_settings.get_value("General", "import_options", {}).project_settings

	var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection
	ProjectSettingsGroup.get_node("MetadataCheckBox").button_pressed = plugin_settings.get_value("ProjectSettings", "metadata", false)
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
