extends Control

var main_sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	LittleGS.add_options_panel_to_scene(self)
	LittleGS.play_music("ambientcave",70)
	LittleGS.play_sound("dungeon_steps",70)
	LittleGS.add_button_behavior($Button,self,"on_click_button")
	LittleGS.connect("languaje_change",self,"on_change_lang")
	$Button/lb_name2.text = Lang.get_text("tx_play")
	if !Utils.is_mobile:$lb_mobile.queue_free()

func on_click_button():
	$Button.disabled = true
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene("res://scenes/PartySelection.tscn")

func on_change_lang(lang):
	LittleGS.stop_all_sounds()
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().reload_current_scene()

func _process(delta):
	if Input.is_action_just_pressed("buttonA"):
		var pos = get_node("Button").rect_global_position + get_node("Button").rect_size/2
		get_viewport().warp_mouse(pos)
		yield(get_tree().create_timer(.2),"timeout")
		var e = InputEventMouseButton.new()
		e.position = pos
		e.button_index = BUTTON_LEFT
		e.button_mask = BUTTON_LEFT
		e.pressed = true
		print(e)
		Input.parse_input_event(e)
		#get_tree().input_event(e)
