extends Node

signal resolved_defiance()

var DEFIANCES = {
	"goblin":{"type":"enemy", "hp":5, "dam":2, "give_item":0.5},
	"rat":{"type":"enemy", "hp":3, "dam":1},
	"bat":{"type":"enemy", "hp":2, "dam":1},
	"gorok":{"type":"enemy", "hp":7, "dam":2, "allways_damage":true},
	"trap":{"type":"trap", "dif":4,"dam":2},
	"door":{"type":"door", "req":["HN","EY"], "give_item":0.2, "snd":"open"},
	"debris":{"type":"block", "hp":3, "give_item":0.2},
	"wchest":{"type":"chest","tier":1, "req":["HN","HN"],"give_item":1,"snd":"open"},
	"chest":{"type":"chest","tier":2, "req":["HN","HN","HN","EY","EY"],"give_item":1,"snd":"open"},
	"stairs":{"type":"stairs"},
	"fountain":{"type":"fountain","uses":2},
}

func get_defiance_data(code):
	var code_arr = code.split("@")
	code = code_arr[0]
	var data = DEFIANCES[code].duplicate(true)
	data.name = code
	if "hp" in data: data["hpm"] = data.hp
	if "prg" in data: data["prgm"] = data.prg
	if "prg" in data: data["prg"] = 0
	if "req" in data: 
		if data.name=="wchest": for i in range(DungeonManager.dungeon_level-1): data.req.append("EY")
		randomize()
		if data.name=="door": 
			for i in range(DungeonManager.dungeon_level-1): 
				if randf()<.25: data.req.append("EY") 
				elif randf()<.25: data.req.append("HN")
		data["req_solved"] = []
		for i in data.req: data["req_solved"].append(false)
	if "dif" in data && data.name=="trap": data.dif = 3 + DungeonManager.dungeon_level
	if "hide" in code_arr: data["hide"] = true
	return data

func get_random_defiance(perc = 100):
	randomize()
	if randi()%100<perc: return null
	var i = randi()%DEFIANCES.keys().size()
	return DEFIANCES.keys()[i]

func resolve_current_defiance():
	Utils.disable_input(1.0)
	var getted_item = check_give_item_on_resolve()
	var def = DungeonManager.current_room.data.defiance
	if "snd" in def: LittleGS.play_sound(def.snd)
	
	var winner = (def.name=="gorok")
	DungeonManager.current_room.erase_defiance()
	yield(get_tree().create_timer(.5),"timeout")
	if getted_item: get_node("/root/Game/CLUI/ItemList").play_take_item_anim(getted_item)
	DungeonManager.reset_current_room()
	emit_signal("resolved_defiance")
	
	if winner: 
		Utils.disable_input(2.0)
		LittleGS.play_sound("troll_dead")
		yield(get_tree().create_timer(1),"timeout")
		yield(Utils.show_popup("win"),"on_close")
		Utils.show_popup("transition1")
		yield(get_tree().create_timer(1),"timeout")
		get_tree().change_scene("res://scenes/Menu.tscn")

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

func check_give_item_on_resolve():
	var def = DungeonManager.current_room.data.defiance
	if def && "give_item" in def:
		randomize()
		if randf()<=def.give_item:
			if !"tier" in def: def["tier"] = 1
			return ItemManager.add_rnd_item(def["tier"])
