@tool
extends PanelContainer


var ViewerOutput
var PresetsDropdown: OptionButton
var FileDropdown: OptionButton

var plugin


func _enter_tree() -> void:
	ViewerOutput = %ViewerOutput
	PresetsDropdown = %PresetsDropdown
	FileDropdown = %FileDropdown

	%ViewButton.pressed.connect( func():
		var preset_name: String
		var file_name: String
		if !PresetsDropdown.selected == 0:
			preset_name = "/presets" + "/" + PresetsDropdown.get_item_text( PresetsDropdown.selected )
		if !FileDropdown.selected == 0:
			file_name = FileDropdown.get_item_text( FileDropdown.selected ).replace(" ", "_").to_lower()

		clear_output()
		var path: String = plugin.plugin_config_dir + preset_name# + file_name
		if file_name:
			# A formatted file_name does not need to be converted to a file name
			open_file( path, file_name )
		else:
			var dir = DirAccess.open( path )
			# Get all file types that are present in the selected folder via their file names
			for file in dir.get_files():
				if plugin.FileNames.values().has(file):
					# Reconvert file to file_name
					open_file( path, plugin.FileNames.find_key(file) )
		pass )

	%ShowFolderButton.pressed.connect( func():
		var preset: String
		var file: String
		if !PresetsDropdown.selected == 0:
			preset = "/presets" + "/" + PresetsDropdown.get_item_text( PresetsDropdown.selected )
		if !FileDropdown.selected == 0:
			file = FileDropdown.get_item_text( FileDropdown.selected ).replace(" ", "_").to_lower()

			if !file:
				push_warning("[persistent_settings] Could not open the file's folder. Perhpas it is not saved?")
			else:
				file = "/" + plugin.FileNames.get(file)

		OS.shell_open( plugin.plugin_config_dir + preset + file )
		pass )


func _exit_tree() -> void:
	pass


func update():
	pass


func clear_output():
	var children = ViewerOutput.get_children()
	children.remove_at(0)
	for child in children:
		ViewerOutput.remove_child(child)
		child.queue_free()


# Takes file_name as readable format
func open_file( path: String, raw_name: String = ""):
	var file := ConfigFile.new()
	var file_name = plugin.FileNames[raw_name]
	var load = file.load(path + "/" + file_name)
	#print(path + plugin.FileNames[file_name])
	if !load == Error.OK:
		push_warning(
			"[persistent_settings] An issue occurred while loading file \"%s (%s)\" to view.\
			Perhaps it is not saved? Cancelling view." % [raw_name.capitalize(), file_name])
	else:
		# Generate a section label for files
		var section_label = load("%s/components/section_label.tscn" % [plugin.DEFAULT_RESOURCE_FOLDER]).instantiate()
		section_label.text = "[b]%s[/b]  ( %s ) " % [ raw_name.capitalize(), file_name ]
		ViewerOutput.add_child(section_label)

		# Generate file contents tree
		var tree: Tree = Tree.new()
		var root = tree.create_item()
		var i = 0

		# Get plain file content (stored as list of texts)
		if file.encode_to_text() == "":
			var plain_file = FileAccess.open(path + "/" + file_name, FileAccess.READ)
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
					child = root.create_child()  #child = tree.create_item(root)
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
