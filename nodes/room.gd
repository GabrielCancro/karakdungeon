extends Node2D

var data

func _ready():
	modulate = Color(.5,.5,.5,0)
	Effector.appear(self)
	$Button.connect("button_down",self,"on_click")

func set_data(room_data):
	data = room_data
	$Sprite.visible = false
	$Label.text = str(data.x)+"x"+str(data.y)
	if "defiance" in data: 
		data["defiance"]["def_sprite"] = $Sprite
		$Sprite.visible = true
		$Sprite/Image.texture = load("res://assets/defiances/df_"+data["defiance"]["name"]+".png")
	
	#DOORS
	for d in data.doors.keys():
		get_node("doors/"+d).visible = !data.doors[d]

func on_leave():
	modulate = Color(.5,.5,.5)

func on_enter():
	modulate = Color(1,1,1)

func update():
	set_data(data)

func on_click():
	print("ROOM ",data)
