extends Node

var ALL_ITEMS = {
	"old_dage":{"uses":2,"tier":1},
	"best_heart":{"uses":1,"tier":1,"reload":true},
	"travel_boots":{"uses":2,"tier":1},
	#"blood_amulet":{"uses":2},
	#"magic_missile":{"uses":2},
}
var PARTY_ITEMS = {}

var item

func _ready():
	for i in ALL_ITEMS.keys(): add_item(i)
	pass

func get_item_data(code):
	var data = ALL_ITEMS[code].duplicate()
	data["name"] = code
	if "uses" in data: data["usesm"] = data["uses"]
	return data

func add_item(it_name):
	if it_name in PARTY_ITEMS.keys(): 
		return null
	else:
		PARTY_ITEMS[it_name] = get_item_data(it_name)
		return it_name

func add_rnd_item(tier=null):
	randomize()
	var items = ALL_ITEMS.keys()
	items.shuffle()
	for it_name in items:
		if tier && tier>ALL_ITEMS[it_name].tier: continue
		if add_item(it_name): return it_name
	return null

func recover_uses():
	for it in PARTY_ITEMS:
		if "uses" in it: it.uses = it.usesm
	update_item_list()

func get_party_items():
	return PARTY_ITEMS

func update_item_list():
	get_node("/root/Game/CLUI/ItemList").update_item_list()
	get_node("/root/Game/CLUI/ItemList").update_usables()

func on_use_item(item):
	print("ON USE ITEM ",item.name)
	if (has_method("condition_"+item.name)) && !call("condition_"+item.name,item): return false
	print("condition_success")
	if "uses" in item && item.uses<=0: return false
	if !DungeonManager.current_player: return false
	if (has_method("on_use_"+item.name)):
		call("on_use_"+item.name,item)
		Effector.scale_boom(item.ui)
		if "uses" in item: item.uses -=1
	yield(get_tree().create_timer(.5),"timeout")
	update_item_list()

#"old_dage":"best_heart":"blood_amulet":"magic_missile":"travel_boots":
func condition_old_dage(item): return !PlayerManager.current_player_have_dice("SW")
func on_use_old_dage(item): DungeonManager.current_player.ui.add_dice_face("SW")

func condition_best_heart(item): return (PlayerManager.get_dice_amount("SW")>=2) && (DungeonManager.current_player.hp<DungeonManager.current_player.hpm)
func on_use_best_heart(item): PlayerManager.heal_player(DungeonManager.current_player.id,2)

func condition_travel_boots(item): return (PlayerManager.get_dice_amount("BT")>=2)
func on_use_travel_boots(item): 
	DungeonManager.current_player.mov = DungeonManager.current_player.movm
	DungeonManager.current_player.mov += PlayerManager.get_dice_amount("BT")
	DungeonManager.current_player.action = true
	DungeonManager.current_player.ui.quit_dice("BT")
	DungeonManager.reset_current_room()
	DungeonManager.current_player.ui.updateUI()

