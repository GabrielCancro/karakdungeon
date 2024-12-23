extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_current_player_dices():
	var player = get_node("/root/Game/CLUI/PlayerUI")
	return player.get_dices()

func current_player_have_dice(val):
	var dices = get_current_player_dices()
	for d in dices: if d == val: return true
	return false
