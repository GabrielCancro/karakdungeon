extends ColorRect

var skip_tuto = false
var viewed = []
signal close_popup()

func _ready():
	modulate.a = 0
	visible = false
	$Panel/ButtonOk/Button.connect("button_down",self,"on_click_ok")
	$ButtonSkip/Button.connect("button_down",self,"on_click_skip")

func show_tuto(code):
	$Attributes.visible = false
	if skip_tuto or code in viewed:
		yield(get_tree().create_timer(0.05),"timeout")
		emit_signal("close_popup")
	else:
		Utils.DISABLED_ACTIONS = true
		viewed.append(code)
		$Panel/lb_desc.text = Lang.get_text("tuto_"+code)
		modulate.a = 0
		visible = true
		Effector.appear(self)
		if code=="dices": 
			yield(get_tree().create_timer(1),"timeout")
			for p in PlayerManager.PLAYERS: p.ui.roll_dices()
			yield(get_tree().create_timer(1),"timeout")
			show_attributes_panel()

func hide_tuto():
	Effector.disappear_fast(self,true)
	yield(get_tree().create_timer(0.5),"timeout")
	Utils.DISABLED_ACTIONS = false
	emit_signal("close_popup")

func on_click_ok():
	hide_tuto()

func on_click_skip():
	skip_tuto = true
	hide_tuto()

func show_attributes_panel():
	$Attributes.modulate.a = 0
	$Attributes/RTL.bbcode_text = ""
	$Attributes/RTL.bbcode_text += Lang.get_text("attr_SW")+"\n\n"
	$Attributes/RTL.bbcode_text += Lang.get_text("attr_BT")+"\n\n"
	$Attributes/RTL.bbcode_text += Lang.get_text("attr_HN")+"\n\n"
	$Attributes/RTL.bbcode_text += Lang.get_text("attr_EY")
	$Attributes/RTL.bbcode_text.replace("bbcode_font","bbcode_font2")
	$Attributes/RTL.bbcode_text += ""
	$Attributes/RTL.rect_position.y = 15
	$Attributes.rect_size.y = 30+$Attributes/RTL.get_content_height()
	$Attributes.visible = true
	Effector.appear($Attributes)
