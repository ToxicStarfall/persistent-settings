@tool
extends EditorPlugin


#const MainPanel = preload("res://addons/main_screen/main_panel.tscn")

var main_panel_instance

var EditorToolbar
var EditorMenuBar: MenuBar
var ProjectMenu: PopupMenu


func _enter_tree() -> void:
	_initialize_plugin_variables()
	print(EditorInterface.get_base_control().get_children())

	var settings = EditorInterface.get_editor_settings()
	if settings.has_setting("persistant_settings/editor/property"):
		print("Existing plugin settings")
	else:
		print("Creating plugin settings")
		_create_persistant_editor_settings()

	var config_folder = EditorInterface.get_editor_paths().get_config_dir()
	var dir = DirAccess.open(config_folder)
	if dir:
		print(dir.get_files())
		if dir.dir_exists("persistant_settings"):
			pass

	#main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	#EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	#_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


#func _has_main_screen():
	#return true
#
#func _make_visible(visible):
	#if main_panel_instance:
		#main_panel_instance.visible = visible
#
#func _get_plugin_name():
	#return "Settings"


#func _get_plugin_icon():
	#return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")


func _initialize_plugin_variables():
	var control = Button.new()
	control.text = "Persistant Settings"
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, control)
	control.get_parent().move_child(control, control.get_index() - 3)

	EditorToolbar = control.get_parent()
	EditorToolbar.remove_child(control)

	EditorMenuBar = EditorToolbar.get_child(0)
	ProjectMenu = EditorMenuBar.get_child(1)



func _apply_persistant_plugins():
	pass


func _apply_persistant_settings():
	pass


func _create_persistant_editor_settings():
	var settings = EditorInterface.get_editor_settings()
	# `settings.set("some/property", 10)` also works as this class overrides `_set()` internally.
	settings.set_setting("persistant_settings/editor/property", 10)
	settings.set_setting("persistant_settings/plugins/property", 10)
	# `settings.get("some/property")` also works as this class overrides `_get()` internally.
	settings.get_setting("persistant_settings/editor/property")
	var list_of_settings = settings.get_property_list()

	pass
