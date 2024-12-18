extends Node

var pj
var room
var def
var ACTIONS = {
	"attack":{},
	"evade":{},
	"dissarm":{},
	"unlock":{},
	"force":{},
}

func get_room_actions():
	pj = DungeonManager.current_player
	room = DungeonManager.current_room
	def = null
	if room && "defiance" in room.data: def = room.data.defiance
	var ac_array = []
	for ac_name in ACTIONS.keys():
		if has_method("check_action_"+ac_name):
			if call("check_action_"+ac_name):
				ac_array.append(ac_name)
	return ac_array

func check_action_attack():
	return (def && def.type == "enemy")

func check_action_evade():
	return (def && def.type == "enemy")

func check_action_dissarm():
	return (def && def.type == "trap")

func check_action_unlock():
	return (def && (def.type == "door" or def.type == "chest"))

func check_action_force():
	return (def && (def.type == "door" or def.type == "chest"))
