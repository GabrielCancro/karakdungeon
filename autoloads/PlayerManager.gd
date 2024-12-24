extends Node

var PLAYERS = []

func add_player(player_node):
	var data = {"id":null, "x":1, "y":0, "h":0, "v":1, "node":null, "ui":null, "action":true}
	PLAYERS.append(data)
	data["id"] = PLAYERS.size()
	data["ui"] = get_node("/root/Game/CLUI/PlayerUI"+str(data["id"]))
	data["node"] = player_node
	data["retrait"] = load("res://assets/retraits/retrait_"+str(data["id"])+".png")
	data["ui"].set_player(data["id"])
	change_player(1)
	return data

func get_current_player_dices():
	var playerUI = DungeonManager.current_player.ui
	return playerUI.get_dices()

func current_player_have_dice(val):
	var dices = get_current_player_dices()
	for d in dices: if d == val: return true
	return false

func change_player(id):
	if DungeonManager.current_player: 
		DungeonManager.current_player.node.set_selected(false)
		DungeonManager.current_player.ui.set_selected(false)
	DungeonManager.current_player = PLAYERS[id-1]
	DungeonManager.set_current_room(DungeonManager.current_player.x,DungeonManager.current_player.y)
	DungeonManager.current_player.node.set_selected(true)
	DungeonManager.current_player.ui.set_selected(true)

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
