extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CLUI/Button.connect("button_down",TurnManager,"end_turn")
	DungeonManager.generate_procedural_dungeon()
	yield(get_tree().create_timer(.1),"timeout")
	PlayerManager.change_player(1)
