extends ColorRect

var data
#signal on_hover(name,val,node)

func _ready():
#	$Button.connect("mouse_entered",self,"on_button_hover",[true])
#	$Button.connect("mouse_exited",self,"on_button_hover",[false])
	$Button.connect("button_down",self,"on_click")


func set_data(it_data):
	data = it_data
	data["ui"] = self
	$Img.texture = load("res://assets/items/it_"+data.name+".png")
	if "uses" in data: 
		for m in $VBox.get_children():
			var i = m.get_index()
			if i < data.uses: m.modulate = Color(.7,.7,.7,1)
			elif i < data.usesm: m.modulate = Color(.3,.3,.3,1)
			else: m.modulate = Color(0,0,0,0)

#func on_button_hover(val):
#	emit_signal("on_hover",data.name,val,self)

func on_click():
	if Utils.is_input_disabled(): return
	ItemManager.on_use_item(data)
