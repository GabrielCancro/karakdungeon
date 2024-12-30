extends Node2D

func _ready():
	$CLUI/Button.connect("button_down",TurnManager,"end_turn")
	DungeonManager.connect("new_dungeon",self,"on_new_dungeon")
	DungeonManager.goto_next_level()

func on_new_dungeon():
	$CLUI/lb_level.text = "Nivel "+str(DungeonManager.dungeon_level)
