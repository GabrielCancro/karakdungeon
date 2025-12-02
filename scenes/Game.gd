extends Node2D

var zoom_key_pressed = false

func _ready():
	$CLUI/EndTurnButton/lb_desc.text = Lang.get_text("tx_end_turn")
	LittleGS.add_button_behavior($CLUI/EndTurnButton,self,"on_click_end_turn")
	LittleGS.add_button_behavior($CLUI/TutoButton,self,"on_click_tuto_button")
	LittleGS.add_button_behavior($CLUI/MapButton)
	DungeonManager.connect("new_dungeon",self,"on_new_dungeon")
	DungeonManager.goto_next_level()
	if Utils.is_mobile: $CLUI/EndTurnButton.rect_position.y += 40
	
	AdaptativeHintAuto.add_hint($CLUI/KeyOut,Lang.get_text("hint_key"))
	AdaptativeHintAuto.add_hint($CLUI/Torch,Lang.get_text("hint_torch"))
	AdaptativeHintAuto.add_hint($CLUI/TutoButton,Lang.get_text("hint_show_tuto"))
	AdaptativeHintAuto.add_hint($CLUI/HelpButton,Lang.get_help_attr_hint())
	if Utils.is_mobile: AdaptativeHintAuto.add_hint($CLUI/EndTurnButton,"[color=#707070]"+Lang.get_text("tx_touch_again")+"[/color]")
	Utils.disable_input(2.5)
	yield(get_tree().create_timer(2),"timeout")
	Utils.show_popup("tuto01")

func on_new_dungeon():
	$CLUI/lb_level.text = " "+Lang.get_text("tx_level")+" "+str(DungeonManager.dungeon_level)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Z: zoom_key_pressed = event.pressed

func _process(delta):
	if Utils.is_input_disabled(): return
	var pressed = ($CLUI/MapButton.pressed || zoom_key_pressed)
	if $Camera2D.zoom.x<2 && pressed: $Camera2D.zoom += Vector2(.05,.05)
	if $Camera2D.zoom.x>1 && !pressed: $Camera2D.zoom -= Vector2(.05,.05)
	$Camera2D.offset_v = $Camera2D.zoom.y/2
	if Input.is_action_just_pressed("change_player"): PlayerManager.select_next_player()

func on_click_tuto_button():
	Utils.show_popup("tuto01")

func on_click_end_turn():
	if Utils.is_mobile && AdaptativeHintAuto.currentNode != $CLUI/EndTurnButton: return
	TurnManager.end_turn()
