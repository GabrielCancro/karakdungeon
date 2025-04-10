extends CanvasLayer

signal on_close()

func _ready():
	LittleGS.add_button_behavior($Panel/Button,self,"on_click_close")
	$Panel/Button/lb_name2.text = Lang.get_text("tx_back")
	$Panel/RTL.bbcode_text = Lang.get_text("popup_win")
	set_page()

func on_click_close():
	emit_signal("on_close")
	queue_free()

func set_page(page=null): pass
