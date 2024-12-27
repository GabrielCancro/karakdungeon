extends ColorRect

var ac_name
signal on_hover(action_name,val,node)

func _ready():
	$Button.connect("mouse_entered",self,"on_button_hover",[true])
	$Button.connect("mouse_exited",self,"on_button_hover",[false])
	$Button.connect("button_down",self,"on_click")

func set_action(_name):
	ac_name = _name
	$Label.text = ac_name+" "+ActionManager.get_calculation(ac_name)

func on_click():
	Effector.scale_boom(self)
	ActionManager.run_action(ac_name)
	yield(ActionManager,"end_action")
	TurnManager.on_post_action()

func on_button_hover(val):
	emit_signal("on_hover",ac_name,val,self)
