tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("LittleGS","res://addons/LittleGameSettings/LittleGameSettingsAuto.gd")

func _exit_tree():
	remove_autoload_singleton("LittleGS")

