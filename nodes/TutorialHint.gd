extends ColorRect

func _ready():
	modulate.a = 0
	visible = false
	$ColorRect/Button.connect("button_down",self,"on_click")
	yield(get_tree().create_timer(2),"timeout")
	visible = true
	Effector.appear(self)

func on_click():
	Effector.disappear_fast(self,true)
