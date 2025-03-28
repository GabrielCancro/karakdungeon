tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("AdaptativeHintAuto","res://addons/AdaptativeHint/AdaptativeHintAuto.gd")

func _exit_tree():
	remove_autoload_singleton("AdaptativeHintAuto")

