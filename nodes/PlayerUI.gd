extends ColorRect

var data

func _ready():
	$btn_roll.connect("button_down",self,"roll_dices")
	$btn_select.connect("button_down",self,"on_select")
	roll_dices()

func set_player(id):
	data = PlayerManager.get_player_data(id)
	$TextureRect.texture = data.retrait

func roll_dices():
	for d in $HBoxContainer.get_children():
		d.roll()

func get_dices():
	var arr = []
	for d in $HBoxContainer.get_children(): 
		arr.append(d.value)
	return arr

func on_select():
	PlayerManager.change_player(data.id)

func set_selected(val=$Selector.visible):
	$Selector.visible = val
	
