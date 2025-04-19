extends Node

var ManagerNode
signal languaje_change(lang)

func _ready():
	ManagerNode = preload("res://addons/LittleGameSettings/LittleGameSettingsManagerNode.tscn").instance()
	add_child(ManagerNode)

func add_options_panel_to_scene(scene):
	var options_panel_node = preload("res://addons/LittleGameSettings/LittleSettingsPanel.tscn").instance()
	options_panel_node.ManagerNode = ManagerNode
	scene.add_child(options_panel_node)

func add_button_behavior(btn,callback_node=null,callback_name=null):
	btn.focus_mode = Control.FOCUS_NONE
	btn.rect_pivot_offset = btn.rect_size/2
	if callback_node: 
		btn.connect("button_down",callback_node,callback_name)
		btn.connect("button_down",self,"play_sound",["button"])
	btn.connect("mouse_entered",self,"on_hover_scale",[btn,true])
	btn.connect("mouse_exited",self,"on_hover_scale",[btn,false])

func on_hover_scale(btn,val):
	if val && !btn.disabled: btn.rect_scale = Vector2(1.1,1.1)
	else: btn.rect_scale = Vector2(1,1)

func save_data(_data):
	ManagerNode.save_custom_data(_data)

func load_data():
	return ManagerNode.load_custom_data()

func clear_all_user_data():
	ManagerNode.clear_data()

#get localizated by current languaje string setted in assets/localizated_strings.gd
func get_loc_str(code):
	return ManagerNode.get_localizated_string(code)

func get_current_languaje():
	return ManagerNode.get_lang()

func play_sound(name,vol=100):
	return ManagerNode.play_sound(name,vol)

func play_music(name=null,vol=100):
	return ManagerNode.play_music(name,vol)

func stop_music():
	ManagerNode.stop_music()

func set_custom_sounds_folder(path):
	ManagerNode.custom_sounds_folder = path
