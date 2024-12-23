extends ColorRect

var ac_name

func _ready():
	$Button.connect("button_down",self,"on_click")

func set_action(_name):
	ac_name = _name
	$Label.text = ac_name+" "+ActionManager.get_calculation(ac_name)

func on_click():
	Effector.scale_boom(self)
	ActionManager.run_action(ac_name)
