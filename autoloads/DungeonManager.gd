extends Node

var current_room
var current_player
var have_key = false
var dungeon_level = 0
var total_defs = 0
var resolved_defs = 0
var total_torch = 0

signal change_room()
signal new_dungeon()

var map = {
}

func _ready():
	DefianceManager.connect("resolved_defiance",self,"on_resolve_defiance")

func goto_next_level():
	dungeon_level += 1
	set_torch( 10 + 5 * dungeon_level )
	Utils.remove_all_childs(get_node("/root/Game/Map"))
	get_node("/root/Game/CLUI/Key").visible = false
	have_key = false
	yield(get_tree().create_timer(.1),"timeout")
	map = MapGenerator.generate_new_map(10+5*dungeon_level)
	total_defs = 0
	resolved_defs = 0
	for r in map: if "defiance" in map[r]: total_defs += 1
	print("TOTAL DEFIANCES ",total_defs)
	print("KEY IN ",floor(total_defs*0.8))
	for p in PlayerManager.PLAYERS: 
		if p.hp<=0: p.node.visible = false
		p.node.teleport_to(0,0)
	emit_signal("new_dungeon")
	yield(get_tree().create_timer(.1),"timeout")
	PlayerManager.change_player(1)
	yield(get_tree().create_timer(.1),"timeout")
	TurnManager.end_turn()
	

func create_dungeon_nodes(xx,yy):
	get_or_create_one_room(xx,yy)
	var data = get_room_data(xx,yy)
	if data.doors.left: get_or_create_one_room(xx-1,yy)
	if data.doors.right: get_or_create_one_room(xx+1,yy)
	if data.doors.up: get_or_create_one_room(xx,yy-1)
	if data.doors.down: get_or_create_one_room(xx,yy+1)

func get_or_create_one_room(xx,yy):
	var key = str(xx)+"x"+str(yy)
	if !key in map.keys(): return null
	var rnode = get_node_or_null("/root/Game/Map/"+"r_"+key)
	if !rnode: 
		rnode = preload("res://nodes/Room.tscn").instance()
		rnode.name = "r_"+key
		var rsize = rnode.get_node("image").rect_size
		var room_data = map[key]
		if "defiance" in room_data: room_data.defiance = DefianceManager.get_defiance_data(room_data.defiance)
		rnode.set_data(room_data)
		rnode.position = Vector2(room_data.x*rsize.x,room_data.y*rsize.y)
		get_node("/root/Game/Map").add_child(rnode)
		Utils.set_zindex( rnode.get_node("Sprite"), .1 )
	return rnode

func get_room_data(dx,dy):
	var key = str(dx)+"x"+str(dy)
	if key in map.keys(): return map[key]
	else: return null

func get_room_node(dx,dy):
	var key = str(dx)+"x"+str(dy)
	return get_node_or_null("/root/Game/Map/r_"+key)

func get_room_defiance(room_node=current_room):
	if !room_node: return null
	if !"defiance" in room_node.data: return null
	return room_node.data.defiance

func set_current_room(dx,dy):
	var room = get_room_node(dx,dy)
	if is_instance_valid(current_room): current_room.on_leave()
	if room && room != current_room: Effector.scale_boom(room)
	current_room = room
	if current_room: 
		current_room.update()
		current_room.on_enter()
		get_node("/root/Game/Camera2D").position = room.position
	var def = get_room_defiance(current_room)
	if !def or (def.type!="door" and def.type!="enemy" and def.type!="block"): 
		DungeonManager.create_dungeon_nodes(dx,dy)
	emit_signal("change_room")
	if current_room: print("CURRENT ROOM ",current_room.data)

func reset_current_room():
	set_current_room(current_room.data.x, current_room.data.y)

func force_update():
	current_room.update()
	emit_signal("change_room")

func get_key():
	have_key = true
	var key = get_node("/root/Game/CLUI/Key")
	key.modulate.a = 0
	yield(get_tree().create_timer(.3),"timeout")
	key.rect_position = Vector2(750,300)
	key.visible = true
	Effector.move_to(key,Vector2(750,220))
	Effector.appear(key)
	yield(get_tree().create_timer(1),"timeout")
	Effector.scale_boom(key)
	print(get_node("/root/Game/CLUI/KeyOut").rect_global_position)
	Effector.move_to(key,get_node("/root/Game/CLUI/KeyOut").rect_global_position)

func on_resolve_defiance():
	resolved_defs += 1
	print("RESOLVED ",resolved_defs,"/",total_defs)
	if !have_key && resolved_defs>=floor(total_defs*0.8): get_key()

func find_hide_defiances(xx,yy):
	var key = str(xx)+"x"+str(yy)
	if !key in map.keys(): return
	var rnode = get_node_or_null("/root/Game/Map/"+"r_"+key)
	if !rnode: return
	if "defiance" in rnode.data && "hide" in rnode.data.defiance && rnode.data.defiance.hide:
		randomize()
		var percept = 25 + PlayerManager.get_dice_amount("EY")*25
		print("PERCENT ",percept)
		if randi()%100 < percept: rnode.show_hiden_defiance()

func set_torch(val):
	total_torch = val
	get_node("/root/Game/CLUI/Torch/lb_torch").text = str(total_torch)
	Effector.scale_boom( get_node("/root/Game/CLUI/Torch") )
	get_node("/root/Game/CLUI/Torch/lb_torch").visible = (total_torch>0)
	get_node("/root/Game/CLUI/Torch/img").visible = (total_torch>0)

func dec_torch():
	set_torch(total_torch-1)
	return (total_torch>=0)
