extends ColorRect

var skip_tuto = false
signal close_popup()

func _ready():
	modulate.a = 0
	visible = false
	$Panel/ButtonOk/Button.connect("button_down",self,"on_click_ok")
	$ButtonSkip/Button.connect("button_down",self,"on_click_skip")

func _process(delta):
	Utils.disable_input(.5)

func show_tuto(code):
	if skip_tuto:
		yield(get_tree().create_timer(0.05),"timeout")
		emit_signal("close_popup")
	else:
		set_process(true)
		modulate.a = 0
		visible = true
		Effector.appear(self)

func hide_tuto():
	Effector.disappear_fast(self,true)
	set_process(false)
	yield(get_tree().create_timer(0.5),"timeout")
	emit_signal("close_popup")

func on_click_ok():
	hide_tuto()

func on_click_skip():
	hide_tuto()
