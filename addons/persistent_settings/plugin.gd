@tool
extends EditorPlugin


# Editor variables
const default_project_config_dir: String = "res://.godot/editor"
var default_editor_config_dir: String
var default_plugin_config_dir: String

# Editor nodes
var EditorToolbar
var EditorMenuBar: MenuBar
var ProjectMenu: PopupMenu

# Plugin variables
const default_plugin_config_folder: String = "/persistant_settings_plugin"
var plugin_config_dir: String
var plugin_config_folder: String
var plugin_config_path: String

var plugin_settings: ConfigFile = ConfigFile.new()

const FileNames = {
	"project_settings": "project.godot",
	"favorite_properties": "favorite_properties",
	"favorite_nodes": "favorites.Node",
	"favorite_files": "favorites",
}

# Plugin nodes
# ConfigurationPopup acts weird when hiding it instead of freeing while closing the popup
const configuration_popup_scene = preload("res://addons/persistent_settings/configuration_popup.tscn")
var ConfigurationPopup: Window

var PopupButton: Button = Button.new()


func _disable_plugin() -> void:
	print("disanled")


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
	print("exietd")
	_remove_plugin_nodes()

	print(ConfigurationPopup)
	if ConfigurationPopup:  ConfigurationPopup.queue_free()
	print(ConfigurationPopup)

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

	config_folder = ProjectSettings.globalize_path(config_folder + default_plugin_config_folder)
	#print(config_folder + "/plugin_settings.cfg")
	#print(plugin_settings.encode_to_text())
	#var a = FileAccess.open(config_folder + "/plugin_settings.cfg", FileAccess.READ)
	#print(a.get_as_text())
	#var b = ConfigFile.new()
	#print(b.load(config_folder + "/plugin_settings.cfg"))
	#print(b.encode_to_text())
	#print(b.get_sections())
	#print(")
	#print(plugin_settings.get_value("General", "welcome_message", false))

	if plugin_settings.load(config_folder + "/plugin_settings.cfg") != Error.OK:
		_create_plugin_settings()

	if plugin_settings.get_value("General", "popup_on_launch", false) == false:
		_add_configuration_popup()
	#_apply_plugin_settings()


func _create_plugin_settings():
	var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	config_folder = ProjectSettings.globalize_path(config_folder + default_plugin_config_folder)

	var default_import_options = {
		project_settings = true,
		favorite_properties = true,
		favorite_nodes = true,
		favorite_files = false,
		favorite_objects = false,
		recent_nodes = false,
		recent_objects = false,
		recent_directories = false,
	}
	var default_save_options = {
		project_settings = true,
		favorite_properties = true,
		favorite_nodes = true,
		favorite_files = false,
		favorite_objects = false,
		recent_nodes = false,
		recent_objects = false,
		recent_directories = false,
	}
	plugin_settings.set_value("General", "import_options", default_import_options)
	plugin_settings.set_value("General", "save_options", default_save_options)
	plugin_settings.save(config_folder + "/plugin_settings.cfg")
	#print(plugin_settings.encode_to_text())


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
		ConfigurationPopup.plugin_settings = plugin_settings
		EditorInterface.get_base_control().add_child(ConfigurationPopup)
		#print(ConfigurationPopup)
		ConfigurationPopup.apply_plugin_settings(plugin_settings)

		# Connect signals
		ConfigurationPopup.file_view_requested.connect( _file_view_requested )
		ConfigurationPopup.file_import_requested.connect( _file_import_requested )
		ConfigurationPopup.file_save_requested.connect( _file_save_requested )
		#ConfigurationPopup.file_overwrite_requested.connect( _on_file_overwrite_requested )
		ConfigurationPopup.plugin_settings_saved.connect( _on_plugin_settings_saved )
	else:
		ConfigurationPopup.grab_focus()
		ConfigurationPopup.request_attention()
	#ConfigurationPopup.hide()
	#ConfigurationPopup.force_native = true
	#ConfigurationPopup.show()
	#ConfigurationPopup.move_to_center()
	#ConfigurationPopup.popup_centered()


func _file_view_requested():
	#local_file.load(default_project_config_dir + "/favorite_properties")
	#ConfigurationPopup.viewed_file =
	pass


# Imports the specified file to the project's data folder
func _file_import_requested(files):
	if !files is Array: files = [files]

	for file_name in files:
		if file_name == "project.godot":
			_import_project_settings()
			continue

		var global_file := ConfigFile.new()
		var load_result = global_file.load(plugin_config_path + "/" + file_name)
		if !load_result == Error.OK:  push_error("could not load from global: " + str(load_result))

		# Detect plain unformatted files (non cfg files)
		if global_file.encode_to_text() == "":
			var a = FileAccess.open(plugin_config_path + "/" + file_name, FileAccess.READ)
			var b = FileAccess.open(default_project_config_dir + "/" + file_name, FileAccess.WRITE_READ)
			# Save contents as plain text
			b.store_string( a.get_as_text() )
			b.close()
			print("%s imported" % [file_name])

		else:
			var local_file := global_file
			var save_result = local_file.save(default_project_config_dir + "/" + file_name)
			if !save_result == Error.OK:  push_error("could not save to local: " + str(save_result))
			else:  print("%s imported" % [file_name])


# Saves the specified file to the plugin's global data folder
func _file_save_requested(files, save_path: String = ""):
	if !files is Array: files = [files]

	for file_name in files:
		if file_name == "project.godot":
			_save_project_settings()
			continue
		#if file_name == "plugin_settings.cfg":
			#_save_plugin_settings()
			#continue

		var local_file := ConfigFile.new()
		var load_result = local_file.load(default_project_config_dir + "/" + file_name)
		if !load_result == Error.OK:  push_error("could not load from local: " + str(load_result))

		# Detect plain unformatted files (non cfg files)
		# plain files return error as empty string when attempting to encode to text
		if local_file.encode_to_text() == "":
			# Open as plain file
			var a = FileAccess.open(default_project_config_dir + "/" + file_name, FileAccess.READ)
			var b = FileAccess.open(plugin_config_path + "/" + file_name, FileAccess.WRITE_READ)
			# Save contents as plain text
			b.store_string( a.get_as_text() )
			b.close()
			print("%s saved" % [file_name])

		else:
			var global_file := local_file
			var save_result = global_file.save(plugin_config_path + "/" + file_name)
			if !save_result == Error.OK:  push_error("could not save to global: " + str(save_result))
			else:  print("%s saved" % [file_name])


# Saves the specified file to the plugin's global data folder by overwriting any existing files.
func _file_overwrite_requested():
	pass


func _import_project_settings():
	var local_file := ConfigFile.new()
	var load_result = local_file.load(plugin_config_path + "/" + "project.godot")
	if !load_result == Error.OK:  push_error("could not load from local: " + str(load_result))

	var global_file := local_file
	var save_result = global_file.save("res://" + "project.godot")
	if !save_result == Error.OK:  push_error("could not save to global: " + str(save_result))
	else:  print("%s imported" % ["project.godot"])


func _save_project_settings():
		var local_file := ConfigFile.new()
		var load_result = local_file.load("res://" + "project.godot")
		if !load_result == Error.OK:  push_error("could not load from local: " + str(load_result))

		var global_file := local_file
		if plugin_settings.get_value("ProjectSettings", "include_metadata", false) != true:
			if global_file.has_section("application"):  global_file.erase_section("application")
			if global_file.has_section("editor_plugins"):  global_file.erase_section("editor_plugins")

		var save_result = global_file.save(plugin_config_path + "/" + "project.godot")
		if !save_result == Error.OK:  push_error("could not save to global: " + str(save_result))
		else:  print("%s saved" % ["project.godot"])


func _on_plugin_settings_saved(ImportOptions: Control = null, SaveOptions: Control = null):
	#if ImportOptions and SaveOptions:
		#var import_options = plugin_settings.get_value("General", "import_options", {})
		#for option in import_options.keys():
			#if ImportOptions.has_node(NodePath(option)):
				#import_options[option] = ImportOptions.get_node(option + "/CheckBox").button_pressed#plugin_settings.set_value("General", "import_options", ImportOptions.get_node(import_option + "/CheckBox").button_pressed)
		#plugin_settings.set_value("General", "import_options", import_options)
#
		#var save_options = plugin_settings.get_value("General", "save_options", {})
		#for option in save_options.keys():
			#if SaveOptions.has_node(NodePath(option)):
				#save_options[option] = SaveOptions.get_node(option + "/CheckBox").button_pressed#plugin_settings.set_value("General", "import_options", ImportOptions.get_node(import_option + "/CheckBox").button_pressed)
		#plugin_settings.set_value("General", "save_options", save_options)

	plugin_settings.save(plugin_config_path + "/plugin_settings.cfg")
	#print(plugin_settings.get_value("General", "import_options", {}))


#func plugin_config_folder_exists():
	#var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	#var dir = DirAccess.open(config_folder)
	#if dir:
		#if dir.dir_exists("persistant_settings_plugin"):
			#dir.open("persistant_settings_plugin")
		#else:
			#dir.make_dir("persistant_settings_plugin")
			#dir.open("persistant_settings_plugin")


#func _create_persistant_editor_settings():
	#var settings = EditorInterface.get_editor_settings()
	## `settings.set("some/property", 10)` also works as this class overrides `_set()` internally.
	#settings.set_setting("persistant_settings/editor/property", 10)
	#settings.set_setting("persistant_settings/plugins/property", 10)
	## `settings.get("some/property")` also works as this class overrides `_get()` internally.
	#settings.get_setting("persistant_settings/editor/property")
	#var list_of_settings = settings.get_property_list()
	#pass
