extends Node

var current_room
var current_player
var have_key = false
var total_defs = 0
var resolved_defs = 0

signal change_room()

var map = {
}

func _ready():
	DefianceManager.connect("resolved_defiance",self,"on_resolve_defiance")

func goto_next_level():
	Utils.remove_all_childs(get_node("/root/Game/Map"))
	get_node("/root/Game/CLUI/Key").modulate = Color(.3,.3,.3,.8)
	have_key = false
	yield(get_tree().create_timer(.1),"timeout")
	map = MapGenerator.generate_new_map(15)
	total_defs = 0
	resolved_defs = 0
	for r in map: if "defiance" in map[r]: total_defs += 1
	print("TOTAL DEFIANCES ",total_defs)
	print("KEY IN ",floor(total_defs*0.8))
	for p in PlayerManager.PLAYERS: p.node.teleport_to(0,0)
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
	var exist_room = get_node_or_null("/root/Game/Map/"+"r_"+key)
	if exist_room: return exist_room
	var rnode = preload("res://nodes/Room.tscn").instance()
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
		current_room.on_enter()
		get_node("/root/Game/Camera2D").position = room.position
	var def = get_room_defiance(current_room)
	if !def or (def.type!="door" and def.type!="enemy"): DungeonManager.create_dungeon_nodes(dx,dy)
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
	key.modulate = Color(1,1,1,0)
	var pos = key.rect_global_position
	yield(get_tree().create_timer(.3),"timeout")
	key.rect_position = Vector2(750,300)
	Effector.move_to(key,Vector2(750,220))
	Effector.appear(key)
	yield(get_tree().create_timer(1),"timeout")
	Effector.scale_boom(key)
	Effector.move_to(key,pos)

func on_resolve_defiance():
	resolved_defs += 1
	print("RESOLVED ",resolved_defs,"/",total_defs)
	if !have_key && resolved_defs>=floor(total_defs*0.8): get_key()
