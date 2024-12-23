extends Node2D

var data = null
var dest = Vector2()

func _ready():
	data = PlayerManager.add_player(self)
	$TextureRect.texture = data.retrait
	yield(get_tree().create_timer(0.1),"timeout")
	teleport_to(0,0)

func _process(delta):
	global_position += global_position.direction_to(dest)*global_position.distance_to(dest)*0.1
	for p in PlayerManager.PLAYERS:
		p = p.node
		if p==self: continue
		if p.global_position.distance_to(global_position)<20:
			var dir = p.global_position.direction_to(global_position)*Vector2(data.v,data.h)*2
			p.dest -= dir
			dest += dir
	Utils.set_zindex(self)

func _input(event):
	if DungeonManager.current_player.node!=self: return
	if event.is_action_pressed("ui_up"): move_to(0,-1)
	if event.is_action_pressed("ui_down"): move_to(0,1)
	if event.is_action_pressed("ui_right"): move_to(1,0)
	if event.is_action_pressed("ui_left"): move_to(-1,0)

func move_to(dx,dy):
	print("MOVE")
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
		TurnManager.on_pre_move()
		yield(TurnManager,"end_reaction")
		
		if dx==0 && dy==0:
			TurnManager.on_across_room()
			yield(TurnManager,"end_reaction")
		else:
			TurnManager.on_leave_room()
			yield(TurnManager,"end_reaction")
		
		data.x += dx
		data.y += dy
		DungeonManager.set_current_room(data.x,data.y)
		dest = get_dest_pos()

func teleport_to(xx,yy):
	var room = DungeonManager.get_room_node(xx,yy)
	if room:
		data.x = xx
		data.y = yy
		data.h = 0
		data.v = 1
		DungeonManager.set_current_room(data.x,data.y)
		position = get_dest_pos()
		dest = position
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
	dest = room.position

func anim_action_end():
	dest = get_dest_pos()

func get_dest_pos():
	var room = DungeonManager.get_room_node(data.x,data.y)
	var offset = Vector2(data.h*80,data.v*80)
	return room.position+offset

func set_selected(val):
	$Selector.visible = val
