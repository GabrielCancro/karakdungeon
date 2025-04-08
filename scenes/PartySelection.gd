extends Control

func _ready():
	LittleGS.add_options_panel_to_scene(self)
	LittleGS.play_music("ambientcave",70)
	
	var help_hint_text = Lang.get_text("attr_SW")+"\n\n"+Lang.get_text("attr_BT")+"\n\n"+Lang.get_text("attr_HN")+"\n\n"+Lang.get_text("attr_EY")
	AdaptativeHintAuto.add_hint($HelpButton,help_hint_text)
	
	#1 load you custom data
	var my_data = LittleGS.load_data()
	#2 if is not initialized, set start values
	if !"start_amount" in my_data: my_data = {"start_amount":0}
	#3 modify your custom data
	my_data["start_amount"] += 1
	#4 save data in permanent file
	LittleGS.save_data(my_data)
	#5 print values
	print(my_data)
	
	#you can clear all saved data
	#LittleGS.clear_all_user_data()
	
	$Button.visible = false
	
	$Button.connect("button_down",self,"on_button_click")
	Utils.remove_all_childs($HBox)
	for pdata in PlayerManager.PLAYERS_BASE_DATA:
		var node = preload("res://nodes/PjSelectUI.tscn").instance()
		$HBox.add_child(node)
		node.set_data(pdata)
		node.get_node("Button").connect("button_down",self,"on_select_button_click",[node])

func on_button_click():
	$Button.disabled = true
	PlayerManager.PLAYERS_ID_ARRAY = get_players_selected()
	get_tree().change_scene("res://scenes/Game.tscn")

func on_select_button_click(node):
	var scolor = node.get_node("SelectColor")
	if get_players_selected().size()>=3 && !scolor.visible: return
	LittleGS.play_sound("button")
	scolor.visible = !scolor.visible
	$Button.visible = (get_players_selected().size()==3)

func get_players_selected():
	var arr = []
	for pui in $HBox.get_children():
		if pui.get_node("SelectColor").visible:
			arr.append(pui.get_index())
	return arr
