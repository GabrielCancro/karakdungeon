extends Node2D

func _ready():
	DungeonManager.connect("new_dungeon",self,"on_new_dungeon")
	DungeonManager.goto_next_level()
	AdaptativeHintAuto.add_hint($CLUI/KeyOut,"Una descripcion interesante para mi hint @POTION descripcion interesante para mi hint  descripcion interesante para mi hint ")
	yield(get_tree().create_timer(2),"timeout")
	$CLUI/TutorialHint.show_tuto("start")
	yield($CLUI/TutorialHint,"close_popup")
	$CLUI/TutorialHint.show_tuto("pjui")
	yield($CLUI/TutorialHint,"close_popup")
	$CLUI/TutorialHint.show_tuto("dices")
	yield($CLUI/TutorialHint,"close_popup")
	print("START GAME!!")

func on_new_dungeon():
	$CLUI/lb_level.text = "Nivel "+str(DungeonManager.dungeon_level)

func _process(delta):
	if Utils.is_input_disabled(): return
	if $Camera2D.zoom.x<2 && Input.is_action_pressed("zoom_map"): $Camera2D.zoom += Vector2(.05,.05)
	if $Camera2D.zoom.x>1 && !Input.is_action_pressed("zoom_map"): $Camera2D.zoom -= Vector2(.05,.05)
	if Input.is_action_just_pressed("change_player"): PlayerManager.select_next_player()
