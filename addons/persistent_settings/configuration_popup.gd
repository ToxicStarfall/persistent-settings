@tool
extends Window


#func _init() -> void:
	#print("init")
#
#func _ready():
	#print("hello")
	#pass


func _enter_tree() -> void:
	print("Asdkl")
	#close_requested.connect( func(): hide() )
	%TabBar.tab_changed.connect( _on_tab_changed )


func _exit_tree() -> void:
	print("exit")
	#close_requested.disconnect( _on_close_requested )


func _on_close_requested() -> void:
	print("close")
	#hide()
	pass


func _on_tab_changed(tab):
	for child in %Screens.get_children():
		if child.get_index() == tab:
			child.show()
		else:
			child.hide()
