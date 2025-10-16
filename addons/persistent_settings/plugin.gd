@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.

	var settings = EditorInterface.get_editor_settings()
	# `settings.set("some/property", 10)` also works as this class overrides `_set()` internally.
	settings.set_setting("persistent_settings/property", 10)
	# `settings.get("some/property")` also works as this class overrides `_get()` internally.
	settings.get_setting("persistent_settings/property")
	var list_of_settings = settings.get_property_list()
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


func _apply_persistent_plugins():
	pass


func _apply_persistent_settings():
	pass
