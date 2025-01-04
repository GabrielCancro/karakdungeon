extends ColorRect

var data
signal on_hover(name,val,node)

func _ready():
	$Button.connect("mouse_entered",self,"on_button_hover",[true])
	$Button.connect("mouse_exited",self,"on_button_hover",[false])
	$Button.connect("button_down",self,"on_click")

func set_data(it_data):
	data = it_data
	$Img.texture = load("res://assets/items/it_"+data.name+".png")

func on_button_hover(val):
	emit_signal("on_hover",data.name,val,self)
