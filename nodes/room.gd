extends Node2D

var data

func _ready():
	modulate = Color(.4,.4,.4,1)
	Effector.appear(self)
	$Button.connect("button_down",self,"on_click")

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
	for d in data.doors.keys():
		get_node("doors/"+d).visible = data.doors[d]

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
	
