extends CanvasLayer

signal on_close()
var tuto_index = 0
var tuto_arr = ["tuto_welcome","tuto_pjs","tuto_attr","tuto_defiances","tuto_torch","tuto_end"]

func _ready():
	$Panel/btn_next.connect("button_down",self,"on_click_next",[+1])
	$Panel/btn_back.connect("button_down",self,"on_click_next",[-1])
	$Panel/btn_skip.connect("button_down",self,"on_click_close")
	$Arrow1.rect_global_position =  Vector2(15,-20)+PlayerManager.get_player_data(1).ui.rect_global_position
	$Arrow2.rect_global_position =  Vector2(15,-20)+PlayerManager.get_player_data(2).ui.rect_global_position
	$Arrow3.rect_global_position =  Vector2(15,-20)+PlayerManager.get_player_data(3).ui.rect_global_position
	set_page()

func on_click_close():
	emit_signal("on_close")
	queue_free()

func on_click_next(val):
	tuto_index += val
	if tuto_index>=tuto_arr.size(): on_click_close()
	else: set_page(tuto_arr[tuto_index])

func set_page(page=null):
	$Panel/RTL.bbcode_text = Lang.get_text(tuto_arr[tuto_index])
	update_arrow_buttons()

func update_arrow_buttons():
	$Panel/btn_back.disabled = tuto_index<=0
	$Panel/btn_next.disabled = tuto_index>=tuto_arr.size()-1
	$Panel/Button/lb_name2.text = str(tuto_index+1)+"/"+str(tuto_arr.size())
	if $Panel/btn_back.disabled: $Panel/btn_back.modulate = Color(.5,.5,.5,1)
	else: $Panel/btn_back.modulate = Color(1,1,1,1)
	if $Panel/btn_next.disabled: $Panel/btn_next.modulate = Color(.5,.5,.5,1)
	else: $Panel/btn_next.modulate = Color(1,1,1,1)
