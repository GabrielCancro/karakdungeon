extends ColorRect
#
#var holding = false
#var time = 0

func _ready():
	$Button.connect("button_down",self,"on_click")
#	$Button.connect("button_down",self,"on_hold",[true])
#	$Button.connect("button_up",self,"on_hold",[false])

#func _process(delta):
#	color = Color(.1+time*.6,.1+time*.6,.2+time*.3)
#	if !holding: 
#		time = 0
#		return
#	time += delta
#	if time>=.6:
#		on_hold(false)
#		Effector.scale_boom(self)
#		TurnManager.end_turn()

#func on_hold(val):
#	if Utils.is_input_disabled(): return
#	time = 0
#	holding = val

func on_click():
	Effector.scale_boom(self)
	TurnManager.end_turn()
