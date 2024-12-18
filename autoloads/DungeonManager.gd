extends Node

var current_room
var current_player

var map = {
	"0x0":{"type":"empy", "defiance":"goblin"},
	"0x1":{"type":"empy"},
	"1x0":{"type":"empy", "defiance":"trap1"},
	"1x1":{"type":"empy", "defiance":"goblin"},
	"2x0":{"type":"empy"},
	"2x1":{"type":"empy"},
}

func _ready():
	generate_procedural_dungeon()

func generate_procedural_dungeon():
	map = {}
	for x in range(-5,5):
		for y in range(-5,5):
			var key = str(x)+"x"+str(y)
			map[key] = {"type":"empy","x":x,"y":y}
			var def = DefianceManager.get_random_defiance(50)
			if def: map[key]["defiance"] = def

func create_dungeon_nodes(xx,yy):
	for x in range(xx-1,xx+2):
		for y in range(yy-1,yy+2):
			var key = str(x)+"x"+str(y)
			if !key in map.keys(): continue
			if get_node_or_null("/root/Game/Map/"+"r_"+key): continue
			var rnode = preload("res://nodes/room.tscn").instance()
			rnode.name = "r_"+key
			var rsize = rnode.get_node("image").rect_size
			var room_data = map[key]
			rnode.set_data(room_data)
			rnode.position = Vector2(room_data.x*rsize.x,room_data.y*rsize.y)
			get_node("/root/Game/Map").add_child(rnode)
			Utils.set_zindex( rnode.get_node("Sprite"), .1 )

func get_room_data(dx,dy):
	var key = str(dx)+"x"+str(dy)
	if key in map.keys(): return map[key]
	else: return null

func get_room_node(dx,dy):
	var key = str(dx)+"x"+str(dy)
	return get_node_or_null("/root/Game/Map/r_"+key)

func set_current_room(dx,dy):
	var room = get_room_node(dx,dy)
	if room && room != current_room: Effector.scale_boom(room)
	current_room = room
	get_node("/root/Game/CLUI/ActionList").show_current_actions(current_room,current_player)
