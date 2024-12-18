extends Node


var ACTIONS = {
	"attack":{},
	"evade":{},
	"dissarm":{},
}

func get_room_actions():
	var pj = DungeonManager.current_player
	var room = DungeonManager.current_room
	var def = DungeonManager.current_room.defiance
	var ac_array = []
	for ac_name in ACTIONS.keys():
		if has_method("check_action_"+ac_name):
			if call("check_action_"+ac_name):
				ac_array.append(ac_name)
	return ac_array

func check_action_attack():
	return true
