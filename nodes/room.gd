extends Node2D

var data

func _ready():
	modulate = Color(.5,.5,.5,0)
	Effector.appear(self)

func set_data(room_data):
	data = room_data
	$Sprite.visible = false
	$Label.text = str(data.x)+"x"+str(data.y)
	if "defiance" in data: 
		$Sprite.visible = true
		$Sprite.texture = load("res://assets/defiances/df_"+data["defiance"]["name"]+".png")

func on_leave():
	modulate = Color(.5,.5,.5)

func on_enter():
	modulate = Color(1,1,1)

func update():
	set_data(data)
