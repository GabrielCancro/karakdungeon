extends CanvasLayer

signal on_close()
var tuto_index = 0
var tuto_arr = ["tuto_welcome","tuto_pjs","tuto_attr","tuto_defiances","tuto_torch","tuto_end"]

func _ready():
	LittleGS.add_button_behavior($Panel/btn_next,self,"on_click_next")
	LittleGS.add_button_behavior($Panel/btn_back,self,"on_click_back")
	LittleGS.add_button_behavior($Panel/btn_skip,self,"on_click_close")
	AdaptativeHintAuto.add_hint($HelpButton,Lang.get_help_attr_hint())
	set_page()

func on_click_close():
	LittleGS.play_sound("button")
	emit_signal("on_close")
	queue_free()

func on_click_next(val=1):
	LittleGS.play_sound("button")
	tuto_index += val
	if tuto_index>=tuto_arr.size(): tuto_index = tuto_arr.size()-1
	if tuto_index<=0: tuto_index = 0
	set_page(tuto_arr[tuto_index])

func on_click_back():
	on_click_next(-1)

func set_page(page=null):
	$Panel/RTL.bbcode_text = Lang.get_text(tuto_arr[tuto_index])
	$Panel/Button/lb_name2.text = str(tuto_index+1)+"/"+str(tuto_arr.size())
	$Panel/btn_back.visible = (tuto_index>0)
	$Panel/btn_next.visible = (tuto_index<tuto_arr.size()-1)
	if $Panel/btn_next.visible: $Panel/btn_skip/lb_name2.text = Lang.get_text("tx_skip_tutorial")
	else: $Panel/btn_skip/lb_name2.text = Lang.get_text("tx_close_tutorial")
	update_actions_buttons()
	update_clipped_bg()

func update_actions_buttons():
	$HelpButton.visible = (tuto_index==2)
	if tuto_index==3: 
		$ActionNode.visible = true
		$ActionNode.get_node("Label").text = Lang.get_text("ac_name_attack")
		$ActionNode.get_node("lb_bon").text = "-"
		$ActionNode2.visible = true
		$ActionNode2.get_node("Label").text = Lang.get_text("ac_name_dissarm")
		$ActionNode2.get_node("lb_bon").text = "-"
	else:
		$ActionNode.visible = false
		$ActionNode2.visible = false

func update_clipped_bg():
	var size = Vector2()
	var offset = Vector2()
	if tuto_index==0:
		size = Vector2(450,150)
		offset = (Vector2(0,0))/-size
	elif tuto_index==1:
		var uipos = PlayerManager.get_player_data(1).ui.rect_global_position + Vector2(-100,-100)
		size = Vector2(1250,400)
		offset = uipos/-size
	elif tuto_index==2:
		var uipos = PlayerManager.get_player_data(1).ui.rect_global_position + Vector2(-100,+50)
		size = Vector2(1250,400)
		offset = uipos/-size
	elif tuto_index==3:
		var uipos = $ActionNode.rect_global_position + Vector2(-20,-30)
		size = Vector2(300,200)
		offset = uipos/-size
	elif tuto_index==4:
		size = Vector2(250,150)
		offset = (Vector2(1600-size.x,0))/-size
	($ClippedBg.material as ShaderMaterial).set_shader_param("clip_texture_size",size);
	($ClippedBg.material as ShaderMaterial).set_shader_param("clip_texture_offset",offset);
