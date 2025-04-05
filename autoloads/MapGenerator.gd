extends Control

var room_node
var map = {}
var last_nodes = []
var new_nodes = []
var rooms_amount = 10
var percent_of_door = 30

# Called when the node enters the scene tree for the first time.
func generate_new_map(_rooms_amount,generate_by_steps=false):
	clear_map()
	rooms_amount = _rooms_amount
	randomize()
	create_new_room(0,0)
	if !generate_by_steps:
		while rooms_amount>0: next_step_generation()
		next_step_generation()
	add_defiances()
	return map

func clear_map():
	map = {}
	last_nodes = []
	new_nodes = []

func next_step_generation():
	last_nodes = new_nodes
	if rooms_amount>0 && last_nodes.size()==0: add_one_random_door()
	if rooms_amount<=0: remove_unconnected_doors()
	new_nodes = []
	for r in last_nodes:
		var room_data = map[r]
		room_data.is_creted_in_last_step = false
		if room_data.doors.up: create_new_room(room_data.x,room_data.y-1)
		if room_data.doors.down: create_new_room(room_data.x,room_data.y+1)
		if room_data.doors.left: create_new_room(room_data.x-1,room_data.y)
		if room_data.doors.right: create_new_room(room_data.x+1,room_data.y)

func create_new_room(x,y):
	if str(x)+"x"+str(y) in map: return
	if rooms_amount<=0: return
	rooms_amount -= 1
	new_nodes.append(str(x)+"x"+str(y))
	var room_data = {
		"x":x,
		"y":y,
		"doors":{"up":(randi()%100<percent_of_door),"down":(randi()%100<percent_of_door),"left":(randi()%100<percent_of_door),"right":(randi()%100<percent_of_door)},
		"is_creted_in_last_step":true,
	}
	
	if x==0 && y==0: room_data.doors = {"up":true,"down":true,"left":true,"right":true}
	map[str(x)+"x"+str(y)] = room_data
	connect_disconnected_doors(room_data)

func connect_disconnected_doors(room_data):
	#print("CREATING ",room_data.x,"x",room_data.y)
	
	var LEFT = get_room_data(room_data.x-1,room_data.y)
	var RIGHT = get_room_data(room_data.x+1,room_data.y)
	var UP = get_room_data(room_data.x,room_data.y-1)
	var DOWN = get_room_data(room_data.x,room_data.y+1)
	
	if LEFT && (LEFT.doors.right or room_data.doors.left): 
		room_data.doors.left = true
		LEFT.doors.right = true
		#print("  connected LEFT ")
	if RIGHT && (RIGHT.doors.left or room_data.doors.right):
		room_data.doors.right = true
		RIGHT.doors.left = true
		#print("  connected RIGHT ")
	if UP && (UP.doors.down or room_data.doors.up):
		room_data.doors.up = true
		UP.doors.down = true
		#print("  connected UP ")
	if DOWN && (DOWN.doors.up or room_data.doors.down):
		room_data.doors.down = true
		DOWN.doors.up = true
		#print("  connected DOWN ")

func add_one_random_door():
	while true:
		var rnd_key = map.keys()[randi()%map.keys().size()]
		var room_data = map[rnd_key]
		if !room_data.doors.up:
			room_data.doors.up = true
			create_new_room(room_data.x,room_data.y-1)
			return
		elif !room_data.doors.down:
			room_data.doors.down = true
			create_new_room(room_data.x,room_data.y+1)
			return
		elif !room_data.doors.left:
			room_data.doors.left = true
			create_new_room(room_data.x-1,room_data.y)
			return
		elif !room_data.doors.right:
			room_data.doors.right = true
			create_new_room(room_data.x+1,room_data.y)
			return

func remove_unconnected_doors():
	#print("REMOVE UNCONNECTED DOORS")
	for key in map:
		var room_data = map[key]
		if room_data.doors.up: room_data.doors.up = (get_room_data(room_data.x,room_data.y-1) != null)
		if room_data.doors.down: room_data.doors.down = (get_room_data(room_data.x,room_data.y+1) != null)
		if room_data.doors.left: room_data.doors.left = (get_room_data(room_data.x-1,room_data.y) != null)
		if room_data.doors.right: room_data.doors.right = (get_room_data(room_data.x+1,room_data.y) != null)

func get_room_data(x,y):
	if str(x)+"x"+str(y) in map:
		return map[str(x)+"x"+str(y)]
	else:
		return null

func on_reset():
	get_tree().reload_current_scene()

func add_defiances():
	var lv = DungeonManager.dungeon_level
	
	var defs = []
	if lv==1: #15 (6)
		defs=["rat","bat","debris","trap","wchest"]
		for i in range(3): defs.append(get_rnd(["rat","bat","debris"]))
	elif lv==2: #20(11)
		defs=["rat","bat","goblin","goblin","door","door","fountain","wchest"]
		for i in range(4): defs.append(get_rnd(["rat","bat","debris"]))
	elif lv==3: #25 (15)
		defs=["rat","bat","goblin","goblin","door","door","fountain","trap","trap","chest@hide"]
		for i in range(4): defs.append(get_rnd(["rat","bat","debris"]))
		for i in range(3): defs.append(get_rnd(["goblin","trap"]))
	
	defs.append("stairs")
	
	var keys = map.keys()
	keys.shuffle()
	for d in defs: 
		if keys.size()<=0: break
		var k = keys.pop_back()
		if k=="0x0": k = keys.pop_back()
		map[k]["defiance"] = d

func get_rnd(arr):
	randomize()
	return arr[ randi()%arr.size() ]
