@tool
extends PanelContainer


var ViewerOutput
var PresetsDropdown: OptionButton
var FileDropdown: OptionButton

var plugin: EditorPlugin


func _enter_tree() -> void:
	ViewerOutput = %ViewerOutput
	PresetsDropdown = %PresetsDropdown
	FileDropdown = %FileDropdown

	%ViewButton.pressed.connect( func():
		var preset: String
		var file: String
		if !PresetsDropdown.selected == 0:
			preset = "/" + PresetsDropdown.get_item_text( PresetsDropdown.selected )
		if !FileDropdown.selected == 0:
			file = "/" + FileDropdown.get_item_text( FileDropdown.selected )

		#if !file:
			#push_warning("[persistent_settings] Could not view the specified file. Perhpas it isn't saved?")
		#else:
		clear_output()
		for i in DirAccess.open( plugin.presets_dir + preset + file ).get_files():
			open_file( plugin.FileNames.find_key(i) )
			#open_file("project.godot")
			#open_file("favorite_properties")
		pass )

	%ShowFolderButton.pressed.connect( func():
		var preset: String
		var file: String
		if !PresetsDropdown.selected == 0:
			preset = "/" + PresetsDropdown.get_item_text( PresetsDropdown.selected )
		if !FileDropdown.selected == 0:
			file = "/" + FileDropdown.get_item_text( FileDropdown.selected ).replace(" ", "_").to_lower()

		#if !file:
			#push_warning("[persistent_settings] Could not open the file's folder. Perhpas it isn't saved?")
		OS.shell_open( plugin.presets_dir + preset + file )
		pass )


func _exit_tree() -> void:
	pass


func clear_output():
	var children = ViewerOutput.get_children()
	children.remove_at(0)
	for child in children:
		ViewerOutput.remove_child(child)
		child.queue_free()


func open_file( file_name: String ):
	var file := ConfigFile.new()
	var load = file.load(plugin.plugin_config_dir + "/" + plugin.FileNames[file_name])

	# Generate a section label for files
	var section_label = load("%s/components/section_label.tscn" % [plugin.DEFAULT_RESOURCE_FOLDER]).instantiate()
	section_label.text = "[b]%s[/b]  ( %s ) " % [ file_name.capitalize(), plugin.FileNames[file_name] ]
	ViewerOutput.add_child(section_label)

	# Generate file contents tree
	var tree: Tree = Tree.new()
	var root = tree.create_item()
	var i = 0

	# Get plain file content (stored as list of texts)
	if file.encode_to_text() == "":
		var plain_file = FileAccess.open(plugin.plugin_config_dir + "/" + plugin.FileNames[file_name], FileAccess.READ)
		while plain_file.get_position() < plain_file.get_length():
			i += 1
			var item: TreeItem = root.create_child()
			var text = plain_file.get_line()
			item.set_text(0, text)
	# Get config files
	else:
		tree.columns = 2
		for section in file.get_sections():
			var child
			if section:
				child = tree.create_item(root)
				child.set_text(0, "[ %s ]" % [section])
				i += 1
			else:
				child = root

			for property in file.get_section_keys(section):
				i += 1
				var item: TreeItem = child.create_child()
				item.set_text(0, property)
				var value = file.get_value(section, property)
				item.set_text(1, str(value))

	ViewerOutput.add_child(tree)
	tree.hide_root = true
	tree.scroll_vertical_enabled = false
	tree.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	tree.custom_minimum_size.y = i * 30
