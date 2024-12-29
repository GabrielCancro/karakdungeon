extends Node

var current_room
var current_player

signal change_room()

var map = {
}

func _ready():
	pass

func generate_procedural_dungeon():
	map = MapGenerator.generate_new_map(15)

func create_dungeon_nodes(xx,yy):
	var nodes =[[xx-1,yy],[xx,yy-1],[xx,yy],[xx,yy+1],[xx+1,yy], ]
	for pos in nodes: get_or_create_one_room(pos[0],pos[1])

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
	if current_room: current_room.on_leave()
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
