extends Node

var ALL_ITEMS = {
	"old_dage":{"uses":3},
	"collar2":{},
	"collar3":{},
}
var PARTY_ITEMS = {}

var item

func _ready():
	add_rnd_item()
	add_rnd_item()

func get_item_data(code):
	var data = ALL_ITEMS[code].duplicate()
	data["name"] = code
	if "uses" in data: data["usesm"] = data["uses"]
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

func update_item_list():
	get_node("/root/Game/CLUI/ItemList").update_item_list()

func on_use_item(item):
	print("ON USE ITEM ",item.name)
	if (has_method("on_use_"+item.name)):
		call("on_use_"+item.name,item)

func on_use_old_dage(item):
	if item.uses>0 && !PlayerManager.current_player_have_dice("SW"):
		item.uses -= 1
		update_item_list()
		DungeonManager.current_player.ui.add_dice_face("SW")
