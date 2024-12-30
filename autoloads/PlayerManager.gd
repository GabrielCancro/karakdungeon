extends Node

var PLAYERS = []

func add_player(player_node):
	var data = {"id":null, "x":1, "y":0, "h":0, "v":1, 
		"node":null, "ui":null, "action":true,
		"hp":5,"hpm":5,"mov":5,"movm":5}
	PLAYERS.append(data)
	data["id"] = PLAYERS.size()
	data["ui"] = get_node("/root/Game/CLUI/PlayerUI"+str(data["id"]))
	data["node"] = player_node
	data["retrait"] = load("res://assets/retraits/retrait_"+str(data["id"])+".png")
	data["ui"].set_player(data["id"])
	return data

func get_current_player_dices():
	if !DungeonManager.current_player: return []
	var playerUI = DungeonManager.current_player.ui
	return playerUI.get_dices()

func current_player_have_dice(val):
	var dices = get_current_player_dices()
	for d in dices: if d == val: return true
	return false

func get_dice_amount(dice):
	var amount = 0
	for d in get_current_player_dices():
		if d==dice: amount += 1
	return amount

func get_reqs_can_complete():
	var reqs = {}
	var i = 0
	var def = DungeonManager.get_room_defiance()
	for r in def.req: 
		if !def.req_solved[i]:
			if !r in reqs: reqs[r] = 1
			else: reqs[r] += 1 
		i+=1
	var amount = 0
	for d in get_current_player_dices():
		if d in reqs:
			reqs[d] -= 1
			if reqs[d] == 0: reqs.erase(d)
			amount += 1
	return amount

func change_player(id):
	if DungeonManager.current_player: 
		DungeonManager.current_player.node.set_selected(false)
		DungeonManager.current_player.ui.set_selected(false)
	DungeonManager.current_player = PLAYERS[id-1]
	DungeonManager.set_current_room(DungeonManager.current_player.x,DungeonManager.current_player.y)
	DungeonManager.current_player.node.set_selected(true)
	DungeonManager.current_player.ui.set_selected(true)
	DungeonManager.current_player.ui.updateUI()

func reorder_players(_x,_y):
	var pjs = []
	for p in PlayerManager.PLAYERS: if p.data.x==_x and p.data.y==_y: pjs.append(p)
	for i in range(pjs.size()):
		var am = pjs.size()
		var p = pjs[i]
		var offset = (-30*(am-1)/2+30*i) * Vector2(p.data.v,p.data.h)
		p.dest = p.get_dest_pos() + offset

func get_player_data(id):
	return PLAYERS[id-1]

func damage_current_player(dam):
	Effector.scale_boom(DungeonManager.current_player.node)
	DungeonManager.current_player.hp -= dam
	DungeonManager.current_player.ui.updateUI()
	var tx = "-"+str(dam)+"HP"
	var node = preload("res://nodes/fx/FloatText.tscn").instance()
	node.set_float(tx,Vector2(20,-40),"damage")
	DungeonManager.current_player.ui.add_child(node)

func set_pj_attr(key,val):
	DungeonManager.current_player[key] = val
	PlayerManager.change_player( DungeonManager.current_player.id )
