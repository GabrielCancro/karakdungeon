extends Control

var main_sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	LittleGS.add_options_panel_to_scene(self)
	LittleGS.play_music("ambientcave",70)
	main_sfx = LittleGS.play_sound("dungeon_steps",40)
	LittleGS.add_button_behavior($Button,self,"on_click_button")
	LittleGS.connect("languaje_change",self,"on_change_lang")
	$Button/lb_name2.text = Lang.get_text("tx_play")

func on_click_button():
	$Button.disabled = true
	main_sfx.stop()
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene("res://scenes/PartySelection.tscn")

func on_change_lang(lang):
	main_sfx.stop()
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().reload_current_scene()
