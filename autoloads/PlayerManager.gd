extends Node

var PLAYERS = []
var PLAYERS_ID_ARRAY = [0,1,2]#FROM PJSELECTION
var PLAYERS_BASE_DATA = [
	{"name":"Maikki",
		"retrait": preload("res://assets/retraits/retrait_1.png"),
		"dices": [
			["NN","NN","SW","BT","HN","EY"], #NETRAL
			["NN","NN","SW","SW","SW","BT"], #COMBAT
			["SW","BT","BT","BT","HN","EY"], #DEXTRE
		],
		"hpm":5, "movm":5, "item":null},
		
	{"name":"Finnius",
		"retrait": preload("res://assets/retraits/retrait_2.png"),
		"dices": [
			["NN","NN","SW","BT","HN","EY"],
			["NN","NN","SW","SW","SW","BT"],
			["NN","BT","HN","EY","HN","EY"], #ASTUTE
		],
		"hpm":5, "movm":5, "item":"thief_knife"},
		
	{"name":"Tarhun",
		"retrait": preload("res://assets/retraits/retrait_3.png"),
		"dices": [
			["NN","NN","SW","BT","HN","EY"],
			["NN","BT","HN","EY","HN","EY"],
			["SW","BT","BT","BT","HN","EY"],
		],
		"hpm":5, "movm":5, "item":null},
	
	{"name":"Kahne",
		"retrait": preload("res://assets/retraits/retrait_4.png"),
		"dices": [
			["NN","NN","SW","BT","HN","EY"],
			["NN","NN","SW","BT","HN","EY"],
			["NN","BT","HN","EY","HN","EY"],
			["SW","BT","BT","BT","HN","EY"],
		],
		"hpm":4, "movm":5, "item":null},
	
	{"name":"Bharash",
		"retrait": preload("res://assets/retraits/retrait_5.png"),
		"dices": [
			["NN","NN","SW","BT","HN","EY"],
			["NN","NN","SW","SW","SW","BT"],
			["NN","NN","SW","SW","SW","BT"],
		],
		"hpm":6, "movm":4, "item":null},
		
	{"name":"Kythana",
		"retrait": preload("res://assets/retraits/retrait_6.png"),
		"dices": [
			["NN","NN","SW","BT","HN","EY"],
			["NN","NN","SW","SW","SW","BT"],
			["NN","BT","HN","EY","HN","EY"],
		],
		"hpm":5, "movm":5, "item":"healing_stuff"},
]

func add_player(player_node):
	var player_index = PLAYERS.size()+1
	var ui = get_node("/root/Game/CLUI/PlayerUI"+str(player_index))
	var data = {"id":player_index, "x":1, "y":0, "h":0, "v":1, "node":player_node, "ui":ui, "action":true}
	data.merge( PLAYERS_BASE_DATA[PLAYERS_ID_ARRAY[player_index-1]] )
	data["hp"] = data["hpm"]
	data["mov"] = data["movm"]
	PLAYERS.append(data)
	data["ui"].set_player(player_index)
	if data["item"]: ItemManager.add_item(data["item"])
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
		if DungeonManager.current_player.id != id: LittleGS.play_sound("coins",80)
		DungeonManager.current_player.node.set_selected(false)
		DungeonManager.current_player.ui.set_selected(false)
	DungeonManager.current_player = PLAYERS[id-1]
	DungeonManager.set_current_room(DungeonManager.current_player.x,DungeonManager.current_player.y)
	DungeonManager.current_player.node.set_selected(true)
	DungeonManager.current_player.ui.set_selected(true)
	DungeonManager.current_player.ui.updateUI()
	get_node("/root/Game/CLUI/ItemList").update_usables()
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
	randomize()
	if dam>0 && randf()<PlayerManager.get_dice_amount("BT")*.1: 
		Effector.show_float_text("-"+str(dam)+"HP "+Lang.get_text("tx_evade"),player.node.position+Vector2(0,-80),"normal")
		dam = 0
	else:
		Effector.show_float_text("-"+str(dam)+"HP",player.node.position+Vector2(0,-80),"damage")
	
	player.hp -= dam
	if player.hp <=0:
		player.hp = 0
		player.mov = 0
		player.action = false
		Effector.disappear(player.ui,true)
		Effector.disappear(player.node,true)
		LittleGS.play_sound("dead1")
		check_all_players_dead()
	elif dam>0: LittleGS.play_sound("hit1")
	else: LittleGS.play_sound("evade",70)
	player.ui.updateUI()

func heal_player(id,val):
	var player = PlayerManager.get_player_data(id)
	Effector.scale_boom(player.node)
	val = min(player.hpm-player.hp,val)
	player.hp += val
	player.ui.updateUI()
	Effector.show_float_text("+"+str(val)+"HP",player.node.position+Vector2(0,-80),"normal")
	LittleGS.play_sound("healt2")

func set_pj_attr(key,val):
	DungeonManager.current_player[key] = val
	PlayerManager.change_player( DungeonManager.current_player.id )

func get_dice_color(faces):
	if faces == ["NN","NN","SW","BT","HN","EY"]: return Color(.6,.6,.6,1)
	if faces == ["NN","NN","SW","SW","SW","BT"]: return Color(.8,.2,.2,1)
	if faces == ["NN","BT","HN","EY","HN","EY"]: return Color(.4,.4,.7,1)
	if faces == ["SW","BT","BT","BT","HN","EY"]: return Color(.2,.8,.2,1)
	return Color(.4,.4,.4,1)

func get_dice_type(faces):
	if faces == ["NN","NN","SW","BT","HN","EY"]: return "neutral"
	if faces == ["NN","NN","SW","SW","SW","BT"]: return "fight"
	if faces == ["NN","BT","HN","EY","HN","EY"]: return "mind"
	if faces == ["SW","BT","BT","BT","HN","EY"]: return "agility"
	return "custom"

func select_next_player():
	if !DungeonManager.current_player: change_player(1)
	else:
		var id = DungeonManager.current_player.id
		for i in range(PLAYERS.size()):
			id += 1
			if id > PLAYERS.size(): id = 1
			if change_player(id): return

func check_all_players_dead():
	var any_live = false
	for i in range(PLAYERS.size()): if PLAYERS[i].hp>0: any_live = true
	if !any_live:  
		Utils.disable_input(2.0)
		yield(get_tree().create_timer(1),"timeout")
		LittleGS.play_sound("all_dead")
		yield(get_tree().create_timer(1),"timeout")
		yield(Utils.show_popup("lose"),"on_close")
		Utils.show_popup("transition1")
		yield(get_tree().create_timer(1),"timeout")
		get_tree().change_scene("res://scenes/Menu.tscn")
