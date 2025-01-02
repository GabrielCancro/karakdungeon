extends Node

var ALL_ITEMS = ["collar1","collar2","collar3"]
var PARTY_ITEMS = []

func _ready():
	pass

func add_rnd_item():
	var items = ALL_ITEMS.duplicate()
	items.shuffle()
	for it in items:
		if it in PARTY_ITEMS: 
			continue
		else:
			PARTY_ITEMS.append(it)
			return true
	return false
