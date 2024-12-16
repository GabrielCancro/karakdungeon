extends Node

var current_room
var current_player

var map = {
	"0x0":{"type":"empy", "defiance":"goblin"},
	"0x1":{"type":"empy"},
	"1x0":{"type":"empy", "defiance":"bear_trap"},
	"1x1":{"type":"empy", "defiance":"goblin"},
	"2x0":{"type":"empy"},
	"2x1":{"type":"empy"},
}

func _ready():
	create_dungeon()

func create_dungeon():
	for key in map.keys():
		map[key]["x"] = int( key.split("x")[0] )
		map[key]["y"] = int( key.split("x")[1] )
	
	print(map)
	for key in map.keys():
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
