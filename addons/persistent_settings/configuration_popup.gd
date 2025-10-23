extends Window


#func _enter_tree() -> void:
	#print("Asdkl")
	#close_requested.connect( func(): hide() )


#func _exit_tree() -> void:
	#close_requested.disconnect()


#func _on_close_requested() -> void:
	#print("ajnsdk")
	#hide()
