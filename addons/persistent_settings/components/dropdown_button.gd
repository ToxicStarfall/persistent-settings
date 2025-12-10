@tool
extends OptionButton


const OFF = preload("res://addons/persistent_settings/icons/GuiTreeArrowRight.svg")
const ON = preload("res://addons/persistent_settings/icons/GuiTreeArrowDown.svg")

const default_text = "Select Preset"


func _enter_tree() -> void:
	toggled.connect( _on_toggled )


func _exit_tree() -> void:
	toggled.disconnect( _on_toggled )


func _on_toggled(toggled_on):
	#if toggled_on:
		#self.icon = ON
	#else:
		#self.icon = OFF
	pass
