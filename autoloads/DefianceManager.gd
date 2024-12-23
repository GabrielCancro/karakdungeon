extends Node

signal resolved_defiance()

var DEFIANCES = {
	"goblin":{"type":"enemy", "hp":5, "dam":2},
	"trap1":{"type":"trap", "dif":4},
	"door1":{"type":"door", "hp":6, "prg":2},
	"chest1":{"type":"chest", "hp":6, "prg":2},
}

var ACTIONS = {
	"enemy":["attack","evade","stun"],
	"trap":["dissarm"],
}

func get_defiance_data(code):
	var data = DEFIANCES[code].duplicate()
	data.name = code
	if "hp" in data: data["hpm"] = data.hp
	if "prg" in data: data["prgm"] = data.prg
	if "prg" in data: data["prg"] = 0
	return data

func get_actions(defiance_type):
	return ACTIONS[defiance_type].duplicate()

func get_random_defiance(perc = 100):
	randomize()
	if randi()%100<perc: return null
	var i = randi()%DEFIANCES.keys().size()
	return DEFIANCES.keys()[i]

func resolve_current_defiance():
	var croom = DungeonManager.current_room.data.erase("defiance")
	DungeonManager.force_update()
	yield(get_tree().create_timer(.5),"timeout")
	DungeonManager.reset_current_room()
	emit_signal("resolved_defiance")
