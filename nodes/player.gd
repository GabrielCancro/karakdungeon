extends Node2D

var data = {
	"x":1, "y":0,"h":0,"v":1,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	DungeonManager.current_player = self
	yield(get_tree().create_timer(0.1),"timeout")
	DungeonManager.create_dungeon_nodes(0,0)
	teleport_to(0,0)

func _input(event):
	if event.is_action_pressed("ui_up"): move_to(0,-1)
	if event.is_action_pressed("ui_down"): move_to(0,1)
	if event.is_action_pressed("ui_right"): move_to(1,0)
	if event.is_action_pressed("ui_left"): move_to(-1,0)

func move_to(dx,dy):
	if dx!=data.h:
		if obstructed_by_door(): return
		data.h = dx
		dx = 0
	elif dx!=0: data.h = -dx
		
	if dy!=data.v:
		if obstructed_by_door(): return
		data.v = dy
		dy = 0
	elif dy!=0: data.v = -dy
	
	var room = DungeonManager.get_room_node(data.x+dx,data.y+dy)
	if room:
		data.x += dx
		data.y += dy
		DungeonManager.set_current_room(data.x,data.y)
		get_node("/root/Game/Camera2D").position = room.position
		var offset = Vector2(data.h*80,data.v*80)
		$Tween.interpolate_property(self,"position",null,room.position+offset,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
		$Tween.start()
		Utils.set_zindex(self,.2)

func teleport_to(xx,yy):
	var room = DungeonManager.get_room_node(xx,yy)
	if room:
		data.x = xx
		data.y = yy
		data.h = 0
		data.v = 1
		DungeonManager.set_current_room(data.x,data.y)
		get_node("/root/Game/Camera2D").position = room.position
		var offset = Vector2(data.h*80,data.v*80)
		position = room.position+offset
		Utils.set_zindex(self,.2)

func obstructed_by_door():
	var room = DungeonManager.current_room
	var def = DungeonManager.get_room_defiance(room)
	if def && def.type=="door":
		if data.x == room.data.x && data.y == room.data.y:
			return true
	return false

func anim_action_start():
	var room = DungeonManager.get_room_node(data.x,data.y)
	$Tween.interpolate_property(self,"position",null,room.position,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	Utils.set_zindex(self,.2)

func anim_action_end():
	var room = DungeonManager.get_room_node(data.x,data.y)
	var offset = Vector2(data.h*80,data.v*80)
	$Tween.interpolate_property(self,"position",null,room.position+offset,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	Utils.set_zindex(self,.2)
