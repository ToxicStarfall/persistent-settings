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
	WelcomeScreen.get_node("%ImportAllButton").pressed.connect(
		func():
			file_import_requested.emit()
	)
	WelcomeScreen.get_node("%ImportPropertiesButton").pressed.connect( func(): file_import_requested.emit() )

	#var ProjectSettingsGroup = %BasicScreen/%ProjectSettingsGroup
	#var InputSettingsGroup = %BasicScreen/%InputsGroup
	#var LayerNamesGroup = %BasicScreen/%LayerNamesGroup
	var file_name = "favorite_properties"
	var FavoritePropertiesGroup = %FavoritesScreen/%PropertiesGroup
	FavoritePropertiesGroup.get_node("%ViewButton").pressed.connect( func(): file_view_requested.emit(file_name) )
	#FavoritePropertiesGroup.get_node("%ImportButton").pressed.connect( func(): file_view_requested.emit(file_name) )
	FavoritePropertiesGroup.get_node("%SaveButton").pressed.connect( func(): file_save_requested.emit(file_name) )
	FavoritePropertiesGroup.get_node("%OverwriteButton").pressed.connect( func(): pass )
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
