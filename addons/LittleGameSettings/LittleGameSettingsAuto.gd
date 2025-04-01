extends Node

var ManagerNode

func _ready():
	ManagerNode = preload("res://addons/LittleGameSettings/LittleGameSettingsManagerNode.tscn").instance()
	add_child(ManagerNode)

func add_options_panel_to_scene(scene):
	var options_panel_node = preload("res://addons/LittleGameSettings/LittleSettingsPanel.tscn").instance()
	options_panel_node.ManagerNode = ManagerNode
	scene.add_child(options_panel_node)

func save_data(_data):
	ManagerNode.save_custom_data(_data)

func load_data():
	return ManagerNode.load_custom_data()

#get localizated by current languaje string setted in assets/localizated_strings.gd
func get_loc_str(code):
	return ManagerNode.get_localizated_string(code)
