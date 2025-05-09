extends Node2D

var data = null
var dest = Vector2()

func _ready():
	data = PlayerManager.add_player(self)
	$TextureProgress.texture_under = data.retrait
	$TextureProgress.texture_progress = data.retrait
	update_hp()
	$Button.connect("button_down",PlayerManager,"change_player",[data.id])
	set_selected(false)

func _process(delta):
	#$Label.text = str(z_index)
	global_position += global_position.direction_to(dest)*global_position.distance_to(dest)*0.1
	for p in PlayerManager.PLAYERS:
		p = p.node
		if p==self: continue
		if p.global_position.distance_to(global_position)<20:
			var dir = Vector2(data.v,data.h)*3
			if data.id==1: dest -= dir
			if data.id==3: dest += dir
	Utils.set_zindex(self)

func _input(event):
	if Utils.is_input_disabled(): return
	if !DungeonManager.current_player: return
	if DungeonManager.current_player.node!=self: return
	if Utils.current_popup: return
	if !data.action: return
	if event is InputEventKey && event.pressed:
		if event.scancode == KEY_W: move_to(0,-1)
		if event.scancode == KEY_S: move_to(0,1)
		if event.scancode == KEY_A: move_to(-1,0)
		if event.scancode == KEY_D: move_to(1,0)

func move_to(dx,dy):
	if data.mov<=0: return
	if obstructed_by_door() && (dx!=data.h || dy!=data.v): return
	
	var dest_mov = get_destine_mov(dx,dy)
	if dest_mov:
		DungeonManager.find_hide_defiances(dest_mov.x,dest_mov.y)
		
		TurnManager.on_pre_move()
		yield(TurnManager,"end_reaction")
		
		var entre_new_room = false
		if data.x==dest_mov.x && data.y==dest_mov.y:
			TurnManager.on_across_room()
			yield(TurnManager,"end_reaction")
		else:
			entre_new_room = true
			TurnManager.on_leave_room()
			yield(TurnManager,"end_reaction")
		
		DungeonManager.get_or_create_one_room(data.x+dx,data.y+dy)
		
		data.mov -= 1
		data.x = dest_mov.x
		data.y = dest_mov.y
		data.h = dest_mov.h
		data.v = dest_mov.v
		LittleGS.play_sound("step")
		data.ui.updateUI()

		DungeonManager.set_current_room(data.x,data.y)
		dest = get_dest_pos()
		if entre_new_room:
			TurnManager.on_enter_room()
			yield(TurnManager,"end_reaction")
		
		TurnManager.on_post_move()
		yield(TurnManager,"end_reaction")

func teleport_to(xx,yy):
	var room = DungeonManager.get_or_create_one_room(xx,yy)
	#print("TELEPORT ",room)
	if room:
		data.x = xx
		data.y = yy
		data.h = 0
		data.v = 1
		DungeonManager.set_current_room(data.x,data.y)
		position = get_dest_pos()
		dest = position

func obstructed_by_door():
	var room = DungeonManager.current_room
	var def = DungeonManager.get_room_defiance(room)
	if def && (def.type=="door" or def.type=="block"):
		if data.x == room.data.x && data.y == room.data.y:
			return true
	return false

func anim_action_start():
	var room = DungeonManager.get_room_node(data.x,data.y)
	dest = room.position+Vector2(data.h,data.v)*20

func anim_action_end():
	dest = get_dest_pos()

func get_dest_pos():
	var room = DungeonManager.get_room_node(data.x,data.y)
	if room:
		var offset = Vector2(data.h*80,data.v*80)
		return room.position+offset
	else:
		return dest

func set_selected(val):
	$Selector.visible = val

func get_destine_mov(dx,dy):
	var mov = {"x":data.x,"y":data.y,"h":0,"v":0}
	if dx!=data.h:
		mov.h = dx
		dx = 0
	elif dx!=0: 
		mov.h = -dx
		
	if dy!=data.v:
		mov.v = dy
		dy = 0
	elif dy!=0: 
		mov.v = -dy
		
	mov.x += dx
	mov.y += dy
	
	var dest_room_data = DungeonManager.get_room_data(mov.x,mov.y)
	if !dest_room_data: return null
	if mov.h==-1 && !dest_room_data.doors.left: return null
	if mov.h==1 && !dest_room_data.doors.right: return null
	if mov.v==1 && !dest_room_data.doors.down: return null
	if mov.v==-1 && !dest_room_data.doors.up: return null
	
	return mov

func update_hp():
	if !data:return
	$TextureProgress.max_value = data.hpm
	$TextureProgress.value = data.hpm - data.hp
