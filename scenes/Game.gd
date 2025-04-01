extends Node2D

func _ready():
	DungeonManager.connect("new_dungeon",self,"on_new_dungeon")
	DungeonManager.goto_next_level()
	
	LittleGS.add_options_panel_to_scene(self)
	LittleGS.play_music("music01")
	LittleGS.play_sound("wind")
	
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
	
	AdaptativeHintAuto.add_hint($CLUI/KeyOut,Lang.get_text("hint_key"))
	AdaptativeHintAuto.add_hint($CLUI/Torch,Lang.get_text("hint_torch"))
	
	yield(get_tree().create_timer(2),"timeout")
	$CLUI/TutorialHint.show_tuto("start")
	yield($CLUI/TutorialHint,"close_popup")
	$CLUI/TutorialHint.show_tuto("pjui")
	yield($CLUI/TutorialHint,"close_popup")
	$CLUI/TutorialHint.show_tuto("dices")
	yield($CLUI/TutorialHint,"close_popup")

func on_new_dungeon():
	$CLUI/lb_level.text = "Nivel "+str(DungeonManager.dungeon_level)

func _process(delta):
	if Utils.is_input_disabled(): return
	var pressed = ($CLUI/MapButton.pressed || Input.is_action_pressed("zoom_map"))
	if $Camera2D.zoom.x<2 && pressed: $Camera2D.zoom += Vector2(.05,.05)
	if $Camera2D.zoom.x>1 && !pressed: $Camera2D.zoom -= Vector2(.05,.05)
	$Camera2D.offset_v = $Camera2D.zoom.y/2
	if Input.is_action_just_pressed("change_player"): PlayerManager.select_next_player()
