extends Node

var DEFIANCES = {
	"goblin":{"type":"enemy", "hp":5, "dam":2},
}

func get_defiance_data(code):
	var data = DEFIANCES[code].duplicate()
	data.name = code
	return data
