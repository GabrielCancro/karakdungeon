extends Node2D

func _ready():
	$CLUI/Button.connect("button_down",TurnManager,"end_turn")
	DungeonManager.goto_next_level()
