extends Node2D

var data
var ttl = randf()

func _ready():
	$shadow.visible = true
	Effector.appear($doors)
	Effector.appear($Sprite)
	Effector.appear($floor)
	$Button.connect("button_down",self,"on_click")

func _process(delta):
	ttl += delta
	$shadow.modulate.a = 0.95+sin(ttl*2)*0.05

func set_data(room_data):
	data = room_data
	$Sprite.visible = false
	#$Label.text = str(data.x)+"x"+str(data.y)
	if "defiance" in data: 
		data["defiance"]["def_sprite"] = $Sprite
		$Sprite.visible = true
		$Sprite/Image.texture = load("res://assets/defiances/df_"+data["defiance"]["name"]+".png")
		if "hide" in data.defiance:
			if data.defiance.hide: $Sprite.modulate.a = 0
	
	#DOORS
	var have_door_defiance = ("defiance" in data && data.defiance.type == "door")
	for d in data.doors.keys():
		var show_door = true
		if have_door_defiance:
			if d=="up": show_door = (DungeonManager.get_room_node(data.x,data.y-1)!=null)
			if d=="down": show_door = (DungeonManager.get_room_node(data.x,data.y+1)!=null)
			if d=="left": show_door = (DungeonManager.get_room_node(data.x-1,data.y)!=null)
			if d=="right": show_door = (DungeonManager.get_room_node(data.x+1,data.y)!=null)
		get_node("doors/"+d).visible = data.doors[d] && show_door


func on_leave():
	pass
	#modulate = Color(.1,.1,.1)

func on_enter():
	modulate = Color(1,1,1)

func update():
	#$Label.text = str($Sprite.z_index)
	set_data(data)
	if DungeonManager.current_player: DungeonManager.current_player.ui.updateUI()

func on_click():
	print("ROOM ",data)
	pass

func show_hiden_defiance():
	if "defiance" in data && "hide" in data.defiance && data.defiance.hide: 
		data.defiance.hide = false
		Effector.appear($Sprite)
		Utils.disable_input(.5)
		update()

func erase_defiance():
	data.erase("defiance")
	Effector.disappear($Sprite)
	yield(get_tree().create_timer(.5),"timeout")
	DungeonManager.force_update()	

func remove_sadow():
	set_process(false)
	if $shadow.visible:
		Effector.disappear($shadow,true)
