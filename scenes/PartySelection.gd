extends Control

func _ready():
	AdaptativeHintAuto.add_hint($HelpButton,Lang.get_text("hint_selection_player"))
	AdaptativeHintAuto.add_hint($HelpButton2,Lang.get_help_attr_hint())
	
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
	$lb_name.text = Lang.get_text("tx_chose_heroes")
	$Button2/lb_name2.text = Lang.get_text("tx_back")
	LittleGS.add_button_behavior($Button2,self,"on_click_back")
	$Button/lb_name2.text = Lang.get_text("tx_goto_dungeon")
	LittleGS.add_button_behavior($Button,self,"on_click_dungeon")
	
	
	update_button_state()
	Utils.remove_all_childs($HBox)
	for pdata in PlayerManager.PLAYERS_BASE_DATA:
		var node = load("res://nodes/PjSelectUI.tscn").instance()
		$HBox.add_child(node)
		node.set_data(pdata)
		node.connect("on_click",self,"on_select_button_click",[node])

func on_click_dungeon():
	PlayerManager.PLAYERS = []
	ItemManager.PARTY_ITEMS = {}
	PlayerManager.PLAYERS_ID_ARRAY = get_players_selected()
	DungeonManager.dungeon_level = 0
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene("res://scenes/Game.tscn")

func on_click_back():
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene("res://scenes/Menu.tscn")

func on_select_button_click(node):
	var scolor = node.get_node("SelectColor")
	if get_players_selected().size()>=3 && !node.selected: return
	LittleGS.play_sound("button")
	node.select(!node.selected)
	update_button_state()

func get_players_selected():
	var arr = []
	for pui in $HBox.get_children():
		if pui.selected:
			arr.append(pui.get_index())
	return arr

func update_button_state():
	if (get_players_selected().size()==3):
		$Button.modulate.a = 1
		$Button.disabled = false
	else:
		$Button.modulate.a = .3
		$Button.disabled = true
