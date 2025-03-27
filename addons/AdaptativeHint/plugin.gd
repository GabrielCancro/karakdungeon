tool
extends EditorPlugin

#var HintPanel
#var ConfigPanel

func _enter_tree():
	#ConfigPanel = preload("res://addons/AdaptativeHint/ConfigPanel.tscn").instance()
	#HintPanel = preload("res://addons/AdaptativeHint/AdaptativeHint.tscn").instance()
	#get_editor_interface().get_editor_viewport().add_child(ConfigPanel)
	#get_node("/root").add_child(HintPanel)
	add_autoload_singleton("AdaptativeHintAuto","res://addons/AdaptativeHint/AdaptativeHintAutoload.gd")
	#add_custom_type("AdaptativeHint","Control",preload("res://addons/AdaptativeHint/AdaptativeHintScript.gd"),preload("res://addons/AdaptativeHint/icon.png"))
	pass

func _exit_tree():
	#if HintPanel: HintPanel.queue_free()
	remove_autoload_singleton("AdaptativeHintAuto")
	#remove_custom_type("AdaptativeHint")

#func has_main_screen():
#	return true
#
#func get_plugin_name():
#	return "AdaptativeHint"
#
#func get_plugin_icon():
#	return get_editor_interface().get_base_control().get_icon("Node","EditorIcons")
