extends ColorRect

var data
#signal on_hover(name,val,node)

func _ready():
#	$Button.connect("mouse_entered",self,"on_button_hover",[true])
#	$Button.connect("mouse_exited",self,"on_button_hover",[false])
	$Button.connect("button_down",self,"on_click")


func set_data(it_data):
	data = it_data
	data["ui"] = self
	var reload = ("reload" in data && data.reload)
	$Button2.visible = reload
	$Img.texture = load("res://assets/items/it_"+data.name+".png")
	if "uses" in data: 
		for m in $VBox.get_children():
			var i = m.get_index()
			if i < data.uses: m.modulate = Color(.7,.7,.7,1)
			elif reload && i < data.usesm: m.modulate = Color(.3,.3,.3,1)
			else: m.modulate = Color(0,0,0,0)
	if reload: color = Color(.2,.2,0,1)
	else: color = Color(0,.2,.35,1)
	var text = "[u][color=#90F090]"+Lang.get_text("it_"+data.name+"_name")+"[/color][/u]\n"+Lang.get_text("it_"+data.name+"_desc")
	if reload: text += "\n[color=#70B070]("+Lang.get_text("it_reload")+")[/color]"
	else: text += "\n[color=#7070B0]("+Lang.get_text("it_reload_not")+")[/color]"
	if Utils.is_mobile: text += "\n[color=#707070]("+Lang.get_text("tx_touch_again")+")[/color]"
	AdaptativeHintAuto.add_hint($Button,text)
	AdaptativeHintAuto.add_hint($Button2,Lang.get_text("hint_reload_item"))

func on_click():
	if Utils.is_input_disabled(): return
	if AdaptativeHintAuto.currentNode != $Button: return
	ItemManager.on_use_item(data)
