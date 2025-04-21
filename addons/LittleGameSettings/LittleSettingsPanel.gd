extends CanvasLayer

var ManagerNode 

# Called when the node enters the scene tree for the first time.
func _ready():
	set_btn($Panel/fullscreen)
	set_btn($Panel/languajes)
	set_btn($Panel/sfx)
	set_btn($Panel/music)
	update_ui()

func set_btn(btn):
	btn.focus_mode = Control.FOCUS_NONE
	btn.rect_pivot_offset = btn.rect_size/2
	btn.connect("button_down",self,"on_click_"+btn.name)
	btn.connect("mouse_entered",self,"on_hover",[btn,true])
	btn.connect("mouse_exited",self,"on_hover",[btn,false])

func on_hover(btn,val):
	if val: btn.rect_scale = Vector2(1.2,1.2)
	else: btn.rect_scale = Vector2(1,1)

func update_ui():
	$Panel/languajes.text = ManagerNode.get_lang()
	if ManagerNode.get_vol("sfx")>0: $Panel/sfx.icon = preload("res://addons/LittleGameSettings/assets/option_panel_icons/ico_sfx_on.png")
	else: $Panel/sfx.icon = preload("res://addons/LittleGameSettings/assets/option_panel_icons/ico_sfx_off.png")
	if ManagerNode.get_vol("music")>0: $Panel/music.icon = preload("res://addons/LittleGameSettings/assets/option_panel_icons/ico_music_on.png")
	else: $Panel/music.icon = preload("res://addons/LittleGameSettings/assets/option_panel_icons/ico_music_off.png")

##BUTTONS FUNCTIONS
func on_click_fullscreen():
	ManagerNode.toogle_fullscreen()
	update_ui()

func on_click_languajes():
	ManagerNode.next_lang()
	LittleGS.emit_signal("languaje_change",ManagerNode.get_lang())
	update_ui()

func on_click_sfx():
	print(ManagerNode.get_vol("sfx"))
	if ManagerNode.get_vol("sfx")==0: ManagerNode.set_vol(100,"sfx")
	else: ManagerNode.set_vol(0,"sfx")
	update_ui()

func on_click_music():
	if ManagerNode.get_vol("music")==0: ManagerNode.set_vol(100,"music")
	else: ManagerNode.set_vol(0,"music")
	update_ui()
