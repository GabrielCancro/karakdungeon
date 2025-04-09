extends Node2D

func _ready():
	DungeonManager.connect("new_dungeon",self,"on_new_dungeon")
	DungeonManager.goto_next_level()
	
	AdaptativeHintAuto.add_hint($CLUI/KeyOut,Lang.get_text("hint_key"))
	AdaptativeHintAuto.add_hint($CLUI/Torch,Lang.get_text("hint_torch"))
	
	var help_hint_text = Lang.get_text("attr_SW")+"\n\n"+Lang.get_text("attr_BT")+"\n\n"+Lang.get_text("attr_HN")+"\n\n"+Lang.get_text("attr_EY")
	AdaptativeHintAuto.add_hint($CLUI/HelpButton,help_hint_text)
	$CLUI/HelpButton.connect("button_down",Utils,"show_popup",["tuto01"])
	
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
