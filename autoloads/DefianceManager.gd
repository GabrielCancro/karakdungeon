extends Node

var DEFIANCES = {
	"goblin":{"type":"enemy", "hp":5, "dam":2},
	"trap1":{"type":"trap", "dif":4, "dam":2},
	"door1":{"type":"door", "hp":6, "dif":2},
	"chest1":{"type":"chest", "hp":6, "dif":2},
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

func get_random_defiance(perc = 100):
	randomize()
	if randi()%100<perc: return null
	var i = randi()%DEFIANCES.keys().size()
	return DEFIANCES.keys()[i]
