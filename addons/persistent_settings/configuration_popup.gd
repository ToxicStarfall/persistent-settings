@tool
extends Window


#var default_editor_config_dir = EditorInterface.get_editor_paths().get_config_dir()
#var default_project_config_dir = "res://.godot/editor"

signal save_requested
#signal overwrite_requested
signal import_requested

#func _init() -> void:
	#print("init")
#
#func _ready():
	#print("hello")
	#pass


func _enter_tree() -> void:
	#print("Asdkl")
	#close_requested.connect( func(): hide() )
	%TabBar.tab_changed.connect( _on_tab_changed )

	%WelcomeScreen/%ImportPropertiesButton.pressed.connect( func(): import_requested.emit() )
	%BasicScreen/%FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( func(): save_requested.emit() )
	%BasicScreen/%FavoritePropertiesGroup.get_node("HBoxContainer/OverwriteButton")


func _exit_tree() -> void:
	#print("exit")
	#close_requested.disconnect( _on_close_requested )
	pass


func _on_close_requested() -> void:
	#print("close")
	#hide()
	pass


func _on_tab_changed(tab):
	for child in %Screens.get_children():
		if child.get_index() == tab:
			child.show()
		else:
			child.hide()
