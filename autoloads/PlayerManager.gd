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
	if data["id"]==1: data["dices"] = [
		["NN","NN","SW","BT","HN","EY"],
		["NN","NN","SW","SW","SW","BT"],
		["NN","NN","SW","SW","SW","BT"],
	]
	if data["id"]==2: data["dices"] = [
		["NN","NN","SW","BT","HN","EY"],
		["NN","NN","SW","SW","SW","BT"],
		["NN","BT","HN","EY","HN","EY"],
	]
	if data["id"]==3: data["dices"] = [
		["NN","NN","SW","BT","HN","EY"],
		["NN","BT","HN","EY","HN","EY"],
		["SW","BT","BT","BT","HN","EY"],
	]
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
	if PLAYERS[id-1].hp<=0: return false
	if DungeonManager.current_player: 
		DungeonManager.current_player.node.set_selected(false)
		DungeonManager.current_player.ui.set_selected(false)
	DungeonManager.current_player = PLAYERS[id-1]
	DungeonManager.set_current_room(DungeonManager.current_player.x,DungeonManager.current_player.y)
	DungeonManager.current_player.node.set_selected(true)
	DungeonManager.current_player.ui.set_selected(true)
	DungeonManager.current_player.ui.updateUI()
	return true

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
	damage_player(DungeonManager.current_player.id,dam)

func damage_player(id,dam):
	var player = PlayerManager.get_player_data(id)
	Effector.scale_boom(player.node)
	player.hp -= dam
	if player.hp <=0:
		player.hp = 0
		player.mov = 0
		player.action = false
		player.ui.visible = false
	player.ui.updateUI()
	Effector.show_float_text("-"+str(dam)+"HP",player.node.position+Vector2(0,-80),"damage")

func heal_player(id,val):
	var player = PlayerManager.get_player_data(id)
	Effector.scale_boom(player.node)
	val = min(player.hpm-player.hp,val)
	player.hp += val
	player.ui.updateUI()
	Effector.show_float_text("+"+str(val)+"HP",player.node.position+Vector2(0,-80),"normal")

func set_pj_attr(key,val):
	DungeonManager.current_player[key] = val
	PlayerManager.change_player( DungeonManager.current_player.id )

func get_dice_color(faces):
	if faces == ["NN","NN","SW","BT","HN","EY"]: return Color(.4,.4,.4,1)
	if faces == ["NN","NN","SW","SW","SW","BT"]: return Color(.8,.2,.2,1)
	if faces == ["NN","BT","HN","EY","HN","EY"]: return Color(.4,.4,.7,1)
	if faces == ["SW","BT","BT","BT","HN","EY"]: return Color(.2,.8,.2,1)
	return Color(.2,.2,.2,1)

func select_next_player():
	if !DungeonManager.current_player: change_player(1)
	else:
		var id = DungeonManager.current_player.id
		for i in range(PLAYERS.size()):
			id += 1
			if id > PLAYERS.size(): id = 1
			if change_player(id): return

#func delete_player(id):
#	var pj = PLAYERS.pop_at(id-1)
#	if DungeonManager.current_player == pj: select_next_player()
#	pj.node.queue_free()
#	pj.ui.queue_free()
