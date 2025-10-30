@tool
extends EditorPlugin


# Editor variables
const default_project_config_dir = "res://.godot/editor"
var default_editor_config_dir
var default_plugin_config_dir

# Editor nodes
var EditorToolbar
var EditorMenuBar: MenuBar
var ProjectMenu: PopupMenu


# Plugin variables
const default_plugin_config_folder = "/persistant_settings_plugin"
var plugin_config_dir
var plugin_config_folder
var plugin_config_path

# Plugin nodes
# ConfigurationPopup acts weird when hiding it instead of freeing while closing the popup
const configuration_popup_scene = preload("res://addons/persistent_settings/configuration_popup.tscn")
var ConfigurationPopup: Window

var PopupButton: Button = Button.new()


func _enter_tree() -> void:
	_initialize_editor_variables()
	_initialize_plugin_variables()
	_initialize_plugin_data()

	#var settings = EditorInterface.get_editor_settings()
	#if settings.has_setting("persistant_settings/editor/property"):
		#print("Existing plugin settings")
	#else:
		#print("Creating plugin settings")
		#_create_persistant_editor_settings()

	#main_panel_instance = MainPanel.instantiate]]()
	# Add the main panel to the editor's main viewport.
	#EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	#_make_visible(false)


func _exit_tree() -> void:
	_remove_plugin_nodes()

	#if main_panel_instance:
		#main_panel_instance.queue_free()


#func _has_main_screen():
	#return true
#
#func _make_visible(visible):
	#if main_panel_instance:
		#main_panel_instance.visible = visible
#
#func _get_plugin_name():
	#return "Settings"
#
#func _get_plugin_icon():
	#return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")


# Initializes editor variables
func _initialize_editor_variables():
	default_editor_config_dir = EditorInterface.get_editor_paths().get_config_dir()
	default_plugin_config_dir = ProjectSettings.globalize_path( default_editor_config_dir )


func _initialize_plugin_variables():
	plugin_config_dir = default_plugin_config_dir
	plugin_config_folder = default_plugin_config_folder
	plugin_config_path = plugin_config_dir + plugin_config_folder

	_add_plugin_nodes()
	PopupButton.get_parent().move_child(PopupButton, PopupButton.get_index() - 3)

	EditorToolbar = PopupButton.get_parent()
	#EditorToolbar = EditorPlugin.CONTAINER_TOOLBAR
	#EditorToolbar.remove_child(control)

	EditorMenuBar = EditorToolbar.get_child(0)
	ProjectMenu = EditorMenuBar.get_child(1)


func _initialize_plugin_data():
	var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	var dir = DirAccess.open(config_folder)
	if dir:
		# TODO: Ask for save location ?
		# Create dir "/plugin_data/persistant_settings" ?
		if dir.dir_exists("persistant_settings_plugin"):
			dir.open("persistant_settings_plugin")
		else:
			dir.make_dir("persistant_settings_plugin")
			dir.open("persistant_settings_plugin")

		_add_configuration_popup()

		#config_folder = ProjectSettings.globalize_path(config_folder + default_plugin_config_folder)
		#var config = ConfigFile.new()
		#config.set_value("Node", "a", "2")
		#print(config.get_value("Node", "a"))
		#config.save(config_folder + "/apples")
		#var a = ConfigFile.new()
		#a.load(config_folder + "apples")
		#print(a.get_value("Node", "a"))


func _add_plugin_nodes():
	PopupButton.text = "Persistant Settings"
	PopupButton.pressed.connect( _add_configuration_popup )
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, PopupButton)


func _remove_plugin_nodes():
	PopupButton.pressed.disconnect( _add_configuration_popup )
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, PopupButton)


func _add_configuration_popup():
	if !ConfigurationPopup:
		ConfigurationPopup = configuration_popup_scene.instantiate()
		ConfigurationPopup.theme = EditorInterface.get_editor_theme()
		ConfigurationPopup.close_requested.connect( func(): ConfigurationPopup.queue_free() )
		EditorInterface.get_base_control().add_child(ConfigurationPopup)

		ConfigurationPopup.save_requested.connect( save_favorite_properties )
		ConfigurationPopup.import_requested.connect( import_favorite_properties )
	else:
		ConfigurationPopup.grab_focus()
		ConfigurationPopup.request_attention()
	#ConfigurationPopup.hide()
	#ConfigurationPopup.force_native = true
	#ConfigurationPopup.show()
	#ConfigurationPopup.move_to_center()
	#ConfigurationPopup.popup_centered()


func import_favorite_properties():
	var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	config_folder = ProjectSettings.globalize_path(config_folder + default_plugin_config_folder)

	var global_favorite_properties := ConfigFile.new()
	global_favorite_properties.load(config_folder + "/favorite_properties")
	var local_favorited_properties := global_favorite_properties
	local_favorited_properties.save(default_project_config_dir + "/favorite_properties")
	print("imported")


func save_favorite_properties():
	var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	config_folder = ProjectSettings.globalize_path(config_folder + default_plugin_config_folder)

	var local_favorited_properties := ConfigFile.new()
	local_favorited_properties.load(default_project_config_dir + "/favorite_properties")
	var global_favorite_properties := local_favorited_properties
	global_favorite_properties.save(plugin_config_path + "/favorite_properties")
	#print( global_favorite_properties.get_sections() )
	print("saved")




#func plugin_config_folder_exists():
	#var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	#var dir = DirAccess.open(config_folder)
	#if dir:
		#if dir.dir_exists("persistant_settings_plugin"):
			#dir.open("persistant_settings_plugin")
		#else:
			#dir.make_dir("persistant_settings_plugin")
			#dir.open("persistant_settings_plugin")


func create_plugin_config_folder():
	pass


func _create_persistant_editor_settings():
	#var settings = EditorInterface.get_editor_settings()
	## `settings.set("some/property", 10)` also works as this class overrides `_set()` internally.
	#settings.set_setting("persistant_settings/editor/property", 10)
	#settings.set_setting("persistant_settings/plugins/property", 10)
	## `settings.get("some/property")` also works as this class overrides `_get()` internally.
	#settings.get_setting("persistant_settings/editor/property")
	#var list_of_settings = settings.get_property_list()
	pass
