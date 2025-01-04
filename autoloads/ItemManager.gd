extends Node

var ALL_ITEMS = {
	"collar1":{},
	"collar2":{},
	"collar3":{},
}
var PARTY_ITEMS = {}

func _ready():
	add_rnd_item()
	add_rnd_item()

func get_item_data(code):
	var data = ALL_ITEMS[code].duplicate()
	data["name"] = code
	return data

func add_rnd_item():
	randomize()
	var items = ALL_ITEMS.keys()
	items.shuffle()
	for it_name in items:
		if it_name in PARTY_ITEMS.keys(): 
			continue
		else:
			PARTY_ITEMS[it_name] = get_item_data(it_name)
			return true
	return false

func get_party_items():
	return PARTY_ITEMS
