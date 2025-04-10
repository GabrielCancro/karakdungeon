extends Control

var ac_name
#signal on_hover(action_name,val,node)

func _ready():
	$Button.connect("button_down",self,"on_click")

func set_action(_name):
	ac_name = _name
	$Label.text = Lang.get_text("ac_name_"+ac_name) + " "
	$lb_bon.text = ActionManager.get_bonif(ac_name)
#	var bnf = ActionManager.get_bonif(ac_name)
#	$ImgBonif.visible = true #(bnf>0)
#	if (bnf>0): $lb_bon.text = str(bnf)
#	else: $lb_bon.text = "-"

func on_click():
	if Utils.is_input_disabled(): return
	Effector.scale_boom(self)
	ActionManager.run_action(ac_name)
	yield(ActionManager,"end_action")
	TurnManager.on_post_action()
