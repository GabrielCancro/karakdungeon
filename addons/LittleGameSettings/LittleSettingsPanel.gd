extends CanvasLayer

var ManagerNode 

# Called when the node enters the scene tree for the first time.
func _ready():
	set_btn($Panel/fullscreen)
	set_btn($Panel/languajes)
	$Panel/languajes.text = ManagerNode.get_lang()

func set_btn(btn):
	btn.focus_mode = Control.FOCUS_NONE
	btn.rect_pivot_offset = btn.rect_size/2
	btn.connect("button_down",self,"on_click_"+btn.name)
	btn.connect("mouse_entered",self,"on_hover",[btn,true])
	btn.connect("mouse_exited",self,"on_hover",[btn,false])

func on_click_fullscreen():
	ManagerNode.toogle_fullscreen()

func on_click_languajes():
	$Panel/languajes.text = ManagerNode.next_lang()

func on_hover(btn,val):
	if val: btn.rect_scale = Vector2(1.2,1.2)
	else: btn.rect_scale = Vector2(1,1)
