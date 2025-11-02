@tool
extends Window


signal file_save_requested
#signal file_overwrite_requested
signal file_import_requested
signal file_view_requested


var viewed_file


#func _init() -> void:
	#print("init")
#
#func _ready():
	#print("hello")
	#pass


func _enter_tree() -> void:
	#close_requested.connect( func(): hide() )
	%TabBar.tab_changed.connect( _on_tab_changed )

	_initialize_buttons()


func _exit_tree() -> void:
	#print("exit")
	#close_requested.disconnect( _on_close_requested )
	pass


func _initialize_buttons():
	var WelcomeScreen = %WelcomeScreen
	WelcomeScreen.get_node("%ImportAllButton").pressed.connect( func(): file_import_requested.emit() )
	WelcomeScreen.get_node("%ImportPropertiesButton").pressed.connect( func(): file_import_requested.emit() )

	var file_name: String
	var node_path: String

	var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsSection
	var FavoritePropertiesGroup = %BasicScreen/%FavoritePropertiesSection
	var FavoriteNodesGroup = %BasicScreen/%FavoriteNodesSection
	var FavoriteFilesGroup = %BasicScreen/%FavoriteFilesSection

	#file_name = "favorite_properties"
	#ProjectSettingsGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	file_name = "favorite_properties"
	#FavoritePropertiesGroup.get_node("HBoxContainer/ViewButton").pressed.connect( file_view_requested.emit.bind( file_name ))
	FavoritePropertiesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	file_name = "favorites.Node"
	FavoriteNodesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))

	file_name = "favorites"
	FavoriteFilesGroup.get_node("HBoxContainer/SaveButton").pressed.connect( file_save_requested.emit.bind( file_name ))



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
