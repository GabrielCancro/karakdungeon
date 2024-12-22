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
			if def && call("check_action_"+ac_name):
				ac_array.append(ac_name)
	return ac_array
	
func get_calculation(ac_name):
	if has_method("get_calculation_"+ac_name):
		return call("get_calculation_"+ac_name)
	return "-"
	
func check_action_attack():
	return (def.type == "enemy")

func check_action_evade():
	return (def.type == "enemy" && PlayerManager.current_player_have_dice("BT"))

func check_action_dissarm():
	return (def.type == "trap")

func check_action_unlock():
	return (def.type == "door" or def.type == "chest")

func check_action_force():
	return (def.type == "door" or def.type == "chest")

func get_calculation_force():
	return "-2HP"
