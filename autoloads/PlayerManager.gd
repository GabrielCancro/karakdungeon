extends Node

var PLAYERS = []

func add_player(player_node):
	PLAYERS.append(player_node)
	change_player(1)
	return PLAYERS.size()

func get_current_player_dices():
	var player = get_node("/root/Game/CLUI/PlayerUI"+str(DungeonManager.current_player.data.id))
	return player.get_dices()

func current_player_have_dice(val):
	var dices = get_current_player_dices()
	for d in dices: if d == val: return true
	return false

func change_player(id):
	DungeonManager.current_player = PLAYERS[id-1]
	DungeonManager.set_current_room(DungeonManager.current_player.data.x,DungeonManager.current_player.data.y)
	for p in PLAYERS: Utils.set_zindex(p)

func reorder_players(_x,_y):
	var pjs = []
	for p in PlayerManager.PLAYERS: if p.data.x==_x and p.data.y==_y: pjs.append(p)
	for i in range(pjs.size()):
		var am = pjs.size()
		var p = pjs[i]
		var offset = (-30*(am-1)/2+30*i) * Vector2(p.data.v,p.data.h)
		p.dest = p.get_dest_pos() + offset
