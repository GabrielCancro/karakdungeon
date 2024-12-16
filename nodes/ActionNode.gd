extends ColorRect

func _ready():
	$Button.connect("button_down",self,"on_click")

func set_action(name):
	$Label.text = name

func on_click():
	Effector.scale_boom(self)
