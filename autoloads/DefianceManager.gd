extends Node

var DEFIANCES = {
	"goblin":{"type":"enemy", "hp":5, "dam":2},
	"bear_trap":{"type":"trap", "dif":4, "dam":2},
}

var ACTIONS = {
	"enemy":["attack","evade","stun"],
	"trap":["dissarm"],
}

func get_defiance_data(code):
	var data = DEFIANCES[code].duplicate()
	data.name = code
	return data

func get_actions(defiance_type):
	return ACTIONS[defiance_type].duplicate()
