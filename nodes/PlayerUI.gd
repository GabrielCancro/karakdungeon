extends ColorRect

var id = null

func _ready():
	for i in range(10): if name=="PlayerUI"+str(i): id=i
	$btn_roll.connect("button_down",self,"roll_dices")
	$btn_select.connect("button_down",self,"on_select")
	roll_dices()

func roll_dices():
	for d in $HBoxContainer.get_children():
		d.roll()

func get_dices():
	var arr = []
	for d in $HBoxContainer.get_children(): 
		arr.append(d.value)
	return arr

func on_select():
	PlayerManager.change_player(id)

func set_selected(val):
	$ColorRect.visible = val
