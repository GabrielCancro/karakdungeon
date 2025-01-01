extends Node

signal resolved_defiance()

var DEFIANCES = {
	"goblin":{"type":"enemy", "hp":5, "dam":2},
	"rat":{"type":"enemy", "hp":3, "dam":1},
	"bat":{"type":"enemy", "hp":2, "dam":1},
	"trap":{"type":"trap", "dif":4,"dam":2},
	"door":{"type":"door", "req":["HN","EY"]},
	"debris":{"type":"block", "hp":3},
	"chest":{"type":"chest", "req":["HN","HN","HN","EY","EY"]},
	"stairs":{"type":"stairs"},
	"fountain":{"type":"fountain","uses":2},
}

func get_defiance_data(code):
	var data = DEFIANCES[code].duplicate()
	data.name = code
	if "hp" in data: data["hpm"] = data.hp
	if "prg" in data: data["prgm"] = data.prg
	if "prg" in data: data["prg"] = 0
	if "req" in data: 
		data["req_solved"] = []
		for i in data.req: data["req_solved"].append(false)
	return data

func get_random_defiance(perc = 100):
	randomize()
	if randi()%100<perc: return null
	var i = randi()%DEFIANCES.keys().size()
	return DEFIANCES.keys()[i]

func resolve_current_defiance():
	var croom = DungeonManager.current_room.data.erase("defiance")
	DungeonManager.force_update()
	yield(get_tree().create_timer(.5),"timeout")
	DungeonManager.reset_current_room()
	emit_signal("resolved_defiance")

func activate_trap(def):
	Effector.scale_boom(DungeonManager.current_room.get_node("Sprite"))
	yield(get_tree().create_timer(.5),"timeout")
	for p in PlayerManager.PLAYERS: 
		if p.x!=DungeonManager.current_room.data.x: continue
		if p.y!=DungeonManager.current_room.data.y: continue
		PlayerManager.damage_player(p.id,def.dam)
		yield(get_tree().create_timer(.1),"timeout")
	yield(get_tree().create_timer(.5),"timeout")
	resolve_current_defiance()
